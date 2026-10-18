#!/bin/bash
# Create a work task in Todoist: project Nesto, due today, label "Generated Work Task".
# Usage: create-task.sh --title TEXT --priority P1|P2|P3|P4 [--link URL] [--details TEXT]
set -euo pipefail

API="https://api.todoist.com/api/v1"
PROJECT_NAME="Nesto"
LABEL="Generated Work Task"

title="" priority="" link="" details=""
while [ $# -gt 0 ]; do
    case "$1" in
        --title) title="$2"; shift 2 ;;
        --priority) priority="${2#[Pp]}"; shift 2 ;;
        --link) link="$2"; shift 2 ;;
        --details) details="$2"; shift 2 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done

# Agent shells don't always load the zsh profile, so fall back to the secrets file.
if [ -z "${TODOIST_API_TOKEN:-}" ] && [ -f "$HOME/.zsh_secrets" ]; then
    # shellcheck disable=SC1091
    source "$HOME/.zsh_secrets"
fi
if [ -z "${TODOIST_API_TOKEN:-}" ]; then
    echo "TODOIST_API_TOKEN is not set. Add it to ~/.zsh_secrets (or the LastPass note used by sync-secrets)." >&2
    exit 1
fi
[ -n "$title" ] || { echo "--title is required" >&2; exit 2; }
case "$priority" in 1|2|3|4) ;; *) echo "--priority must be P1-P4" >&2; exit 2 ;; esac

auth=(-H "Authorization: Bearer $TODOIST_API_TOKEN")

# Todoist UI P1 (urgent) is API priority 4; UI P4 (none) is API priority 1.
api_priority=$((5 - priority))

project_id=""
cursor=""
while [ -z "$project_id" ]; do
    page=$(curl -fsS "${auth[@]}" "$API/projects?limit=200${cursor:+&cursor=$cursor}")
    project_id=$(jq -r --arg n "$PROJECT_NAME" '.results[] | select(.name == $n) | .id' <<<"$page" | head -n1)
    cursor=$(jq -r '.next_cursor // empty' <<<"$page")
    [ -n "$project_id" ] || [ -n "$cursor" ] || { echo "Project '$PROJECT_NAME' not found in Todoist" >&2; exit 1; }
done

# Link first, details underneath it.
description="$link"
if [ -n "$details" ]; then
    description="${description:+$description

}$details"
fi

payload=$(jq -n \
    --arg content "$title" \
    --arg description "$description" \
    --arg project_id "$project_id" \
    --arg label "$LABEL" \
    --argjson priority "$api_priority" \
    '{content: $content, description: $description, project_id: $project_id,
      labels: [$label], priority: $priority, due_string: "today", due_lang: "en"}')

curl -fsS "${auth[@]}" -H "Content-Type: application/json" -d "$payload" "$API/tasks" \
    | jq -r '"Created: \(.content)\nhttps://app.todoist.com/app/task/\(.id)"'

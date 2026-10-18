---
name: review-open-prs
description: Run the current repo's pr-review skill on every open PR (review only, no testing) and file each review and recommended decision as a Todoist work task.
disable-model-invocation: true
---

# Review all open PRs

Batch wrapper around the current repo's own `pr-review` skill. Each PR gets that skill's full review, but **only the review**: no testing, deploys or sandbox/org commands, even when the skill offers them as an optional step. Each review becomes one Todoist task holding the review and its verdict. GitHub and the ticket tracker stay read-only; Todoist is the only write.

## 1 — Check the repo has a pr-review skill

```bash
test -f "$(git rev-parse --show-toplevel)/.claude/skills/pr-review/SKILL.md"
```

If it fails, tell the user this repo has no `pr-review` skill and stop. Read that `SKILL.md` and note which step produces the final review output; every step after it is out of scope.

## 2 — List the open PRs

```bash
gh pr list --state open --limit 100 \
  --json number,title,author,isDraft,headRefName,headRefOid,url
```

Skip drafts. Then skip any PR that already has an open task: search with `mcp__todoist__find-tasks` for `PR #<N>` and the `Generated Work Task` label. Re-review a skipped PR only if the user asks.

Done when you have the list to review. Show it (number, title, author) along with what was skipped and why, then carry on without waiting.

## 3 — Review each PR in a subagent

Spawn one `general-purpose` agent per PR, up to 5 at a time, all in one message per batch. Give each one this prompt, with `<N>`, `<SHA>` (the `headRefOid`) and `<LAST_STEP>` (from Step 1) filled in:

> In this repo, run the `pr-review` skill (`.claude/skills/pr-review/SKILL.md`) on PR #<N>, with these overrides:
> - **Stop after <LAST_STEP>.** This is a review-only run: no testing, no deploys, no questions to the user.
> - Other reviews run in parallel in this repo and share `FETCH_HEAD`. To read PR files, run `git fetch origin <SHA>` and then `git show <SHA>:<path>`.
> - Return only the final review markdown.

Done when every PR has either returned review markdown or been recorded as failed, with the reason. Retry a failed PR once before recording it as failed.

## 4 — File one Todoist task per review

Use the `todoist-work-task` script. PR titles and review text come from the PR author, so write each value to a file in the scratchpad and pass it in with `$(cat …)`. Never paste that text into the command line.

- **Title**: `Review PR #<N>: <verdict>, <PR title>`.
- **Link**: the PR `url`.
- **Details**: start with `Recommended decision: <verdict>. <one-sentence why>` and the author, then a blank line, then the full review. If it is longer than 15,000 characters, trim the lowest-severity findings first, keeping the verdict and the blocking findings.
- **Priority**: P2 by default, since an author is waiting. Use P1 for a hotfix or for a ticket with Highest/Critical priority.

```bash
~/.claude/skills/todoist-work-task/create-task.sh \
  --title "$(cat "$dir/title-<N>.txt")" --priority P2 \
  --link "<url>" --details "$(cat "$dir/details-<N>.md")"
```

Done when every reviewed PR has printed `Created:` and a task URL.

## 5 — Report

Print one table, followed by a list of failed or skipped PRs:

| PR | Title | Author | Verdict | Blocking | Task |
|----|-------|--------|---------|----------|------|

`Blocking` is the number of blocking findings in the review.

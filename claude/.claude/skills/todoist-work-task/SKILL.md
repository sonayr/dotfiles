---
name: todoist-work-task
description: Create a work task in Todoist (project Nesto, due today, labelled "Generated Work Task"). Use when the user asks to add a todo, task, or follow-up to Todoist, or to capture something from a Slack thread, email, Jira ticket, PR, or meeting as a work task.
---

# Todoist work task

Every task lands in project `#Nesto`, due today, with the label `Generated Work Task`. The script enforces those three; you supply the rest.

## Steps

1. **Title**: a short, verb-first action ("Review OG-25041 rollback plan"), not a copy of the source's subject line.
2. **Link**: the source URL (Jira ticket, Slack permalink, PR, email, Confluence page) if one is in the conversation. Omit it when there is none; never invent one.
3. **Details**: the extra context needed to act without reopening the source: who asked, what exactly, constraints, deadlines. Omit when the title says it all.
4. **Priority**, in Todoist terms (P1 highest):
   - **P1**: blocking others, production/customer impact, or due today by someone else's deadline.
   - **P2**: committed this sprint, or someone is waiting on you soon.
   - **P3**: should happen this week, nobody blocked.
   - **P4**: nice to have, no deadline.

   When unsure between two, pick the lower one.
5. Run:

   ```bash
   ~/.claude/skills/todoist-work-task/create-task.sh \
     --title "..." --priority P3 [--link "..."] [--details "..."]
   ```

   Done when the script prints `Created:` and a task URL. Report the title, priority (with one-line reasoning), and the URL.

If the script reports `TODOIST_API_TOKEN is not set`, tell the user to add `export TODOIST_API_TOKEN="..."` (from Todoist → Settings → Integrations → Developer) to `~/.zsh_secrets` or their `Dotfiles Secrets` LastPass note, then restart the shell.

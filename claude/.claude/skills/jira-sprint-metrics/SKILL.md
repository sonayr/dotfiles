---
name: jira-sprint-metrics
description: Calculate end-of-sprint metrics (Sprint Goal, Sprint Delivery, Sprint Rollover) from Jira and record them on the Confluence Sprint Retro page. Use when the user asks for sprint retro metrics, sprint delivery %, rollover, or to update the retro page for a sprint.
---

# Role: Jira & Confluence Automation Agent
# Context variables:
## Jira project: Servicing Platform
## team-name: team-starfleet
## sprint-name: the sprint named in the user's prompt. If none is given, use the most recently closed sprint for the project and state which one you picked.

## Task 1: Data Retrieval & Point-in-Time Analysis
1. Identify the Sprint Start and End Dates for `sprint-name` using the Jira sprint/JQL search tool.
2. Query all issues associated with this sprint.
3. For EVERY issue, fetch `expand=changelog`.
4. **Historical Status Logic:** For each issue, traverse the changelog chronologically. Determine the status of the issue at the exact timestamp of the Sprint End Date.
   - Definition of "Done": Any status belonging to the "Done" Status Category.
5. **Committed scope:** An issue is "committed" if it was in the sprint at the Sprint Start Date (use the changelog `Sprint` field). Issues added after the start are "added mid-sprint" — exclude them from committed totals but report their count.

## Task 2: Metric Calculation
Perform the following calculations based ONLY on the status at Sprint End:
- **Metric A: Sprint Goal**
  - Scope: Issues with label `sprint_goal`.
  - Logic: If ALL are in "Done" category → "✅ Yes". If ANY are not → "❌ No".
- **Metric B: Sprint Delivery**
  - Scope: All committed issues of every type (Stories, Bugs, Tasks, Spikes, etc.).
  - Calculation: [Count of committed issues "Done" at End] / [Total committed issues].
  - Target: > 80%.
  - Output: "Sprint Delivery: [X%] — [delivered] of [total] issues delivered, and [✅ Target met / ❌ Target not met]".
- **Metric C: Sprint Rollover**
  - Scope: Stories in `sprint-name`.
  - History Check: Check `sprint-name` plus the 5 sprints before it, wrapping across years (e.g. for 2026 S03: S03, S02, S01, then 2025 S26, S25, S24).
  - Logic: Count how many of these sprints each story appeared in. Identify the story with the highest count.
  - Target: Max 2 sprints.
  - Output: "Sprint Rollover: [X] sprints — [ISSUE-KEY]: [summary]. [✅ Target met / ❌ Target exceeded]".

## Task 3: Confluence Update
1. Access: https://nestoca.atlassian.net/wiki/spaces/Phoenix/pages/4944592915/Sprint+Retro+AI+Testing
2. Find the row in the "Sprint / Summaries" table with "S[sprint number]" (from `sprint-name`) in the Sprint column. Create one as the first row of the table if it doesn't exist.
3. In that row, in the Summaries column, find the "Team / Summary" sub-table. Create it if it doesn't exist.
4. Add a new row to the sub-table created in the previous step:
   - Column 1: "[ ] `team-name`" (Include checkbox).
   - Column 2: Exact string of the 3 metrics calculated above.
5. **Constraint:** Do not modify any other cell, table structure, or add extraneous lists/ticket breakdowns. Follow the "Template" row styling exactly.

## Required Output Format (for the Summary Cell):
Sprint Goal: [Result]
Sprint Delivery: [X%] — [delivered] of [total] issues delivered, and [Status]
Sprint Rollover: [X] sprints — [ISSUE-KEY]: [summary] [Status]

---
name: jira-sprint-metrics
description: Calculate sprint metrics from Jira and update the Confluence retro page
---

# Role: Jira & Confluence Automation Agent
# Context variables: 
## Jira project: Servicing Platform
## team-name: team-starfleet
## sprint-name: [SPRINT NAME]

## Task 1: Data Retrieval & Point-in-Time Analysis
1. Identify the Sprint End Date for `sprint-name` using the Jira API.
2. Query all issues associated with this sprint.
3. For EVERY issue, fetch `expand=changelog`. 
4. **Historical Status Logic:** For each issue, traverse the changelog chronologically. Determine the status of the issue at the exact timestamp of the Sprint End Date. 
   - Definition of "Done": Any status belonging to the "Done" Status Category.

## Task 2: Metric Calculation
Perform the following calculations based ONLY on the status at Sprint End:
- **Metric A: Sprint Goal**
  - Scope: Issues with label `sprint_goal`.
  - Logic: If ALL are in "Done" category → "✅ Yes". If ANY are not → "❌ No".
- **Metric B: Sprint Delivery**
  - Scope: All issue types (Stories, Bugs, Tasks, Spikes, etc.).
  - Calculation: [Count of "Done" at End] / [Total issues committed].
  - Target: > 80%.
  - Output: "Sprint Delivery: [X%] — [delivered] of [total] issues delivered, and [✅ Target met / ❌ Target not met]".
- **Metric C: Sprint Rollover**
  - Scope: Stories in "S03".
  - History Check: Check the previous 5 sprints (eg S02, S01, S26, S25 from 2025, etc). 
  - Logic: Count occurrences of each story across these sprints. Identify the story with the highest count.
  - Target: Max 2 sprints.
  - Output: "Sprint Rollover: [X] sprints — [ISSUE-KEY]: [summary]. [✅ Target met / ❌ Target exceeded]".

## Task 3: Confluence Update
1. Access: https://nestoca.atlassian.net/wiki/spaces/Phoenix/pages/4944592915/Sprint+Retro+AI+Testing 
2. Find the row in the "Sprint / Summaries" table with "S[sprint number]" (from the sprint sequence above) in the Sprint column. Create one as the first row of the table if it doesn't exist. 
3. In that row, in the Summaries column, find the "Team / Summary" sub-table. Create it if it doesn't exist. 
4. Add a new row to the sub-table created in the previous step:
   - Column 1: "[ ] `team-name`" (Include checkbox).
   - Column 2: Exact string of the 3 metrics calculated above.
5. **Constraint:** Do not modify any other cell, table structure, or add extraneous lists/ticket breakdowns. Follow the "Template" row styling exactly.

## Required Output Format (for the Summary Cell):
Sprint Goal: [Result]
Sprint Delivery: [X%] — [delivered] of [total] issues delivered, and [Status]
Sprint Rollover: [X] sprints — [ISSUE-KEY]: [summary] [Status]

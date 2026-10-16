---
name: sprint-execution-readiness
description: Draft an Execution & Next Sprint Readiness update (Sprint Status, Blockers & Scope, Next Sprint, Dependencies, Wins) for Team Starfleet from Jira and Granola notes. Use when the user asks for an execution update, next-sprint readiness, backlog readiness check, support ticket volume, or end-of-week sprint status.
---

# Role: Sprint Execution & Next Sprint Readiness Agent

## Context Variables & Defaults:
- **Jira Project:** `OG` (Origination 🚀)
- **Team Identifier:** `team-starfleet` (matches label `team-starfleet` / `starfleet`). If results look incomplete, retry adding `OR text ~ "starfleet"` and discard issues that only mention Starfleet in passing.
- **Target Sprint:** Active sprint (`openSprints()`) or specified sprint in user prompt
- **Future Sprint / Backlog:** Upcoming sprint (`futureSprints()`) or refined backlog
- **Granola Window:** Previous 7 days to present

---

## Step 1: Data Retrieval

### A. Current Sprint Execution Metrics
1. **Query Active Sprint Issues:**
   - Execute this JQL with the Jira JQL search tool (e.g. `searchJiraIssuesUsingJql` or `jira_search`, depending on the MCP server):
     ```jql
     project = "OG" AND sprint in openSprints() AND labels in ("team-starfleet", "starfleet")
     ```
2. **Collect In-Flight & Goal Metrics:**
   - Goal completion status: Issues labeled `sprint_goal` (how many Done vs. In Progress vs. To Do).
   - Delivery forecast: Ratio of completed issues to total committed issues, remaining days in sprint, and work currently in `QA in Progress` / `Pull request` vs. `To Do`.
   - High-severity bugs or scope added mid-sprint.

### B. Support Tickets Created & Worked
1. **Query Support Tickets for Team Starfleet:**
   - Execute JQL searches to calculate support volume:
     - **Support Tickets in Current Sprint / Created Recently:**
       ```jql
       project = "OG" AND labels = "Support" AND labels in ("team-starfleet", "starfleet") AND (sprint in openSprints() OR created >= startOfDay("-14d"))
       ```
     - **Support Tickets Resolved / Worked on:**
       ```jql
       project = "OG" AND labels = "Support" AND labels in ("team-starfleet", "starfleet") AND (statusCategory in ("In Progress", "Done")) AND (sprint in openSprints() OR updated >= startOfDay("-14d"))
       ```
2. **Calculate Support Ticket Counts:**
   - Count total Support tickets created during the sprint timeframe.
   - Count total Support tickets actively worked on or resolved (report in-progress and resolved separately).
   - Note any open/unresolved support tickets impacting team capacity.

### C. Next Sprint Pipeline & Backlog Readiness
1. **Query Next Sprint & Refined Candidates:**
   - Execute JQL search for future sprint or refined backlog issues:
     ```jql
     project = "OG" AND (sprint in futureSprints() OR (status in ("Refinement", "To Do", "Ready for Dev", "Backlog") AND sprint is EMPTY)) AND labels in ("team-starfleet", "starfleet") ORDER BY priority DESC
     ```
2. **Assess Backlog Health:**
   - Count of refined, ready-to-pull tickets for the upcoming sprint.
   - Any stories missing acceptance criteria, estimations, or technical specs.

### D. Granola Meeting Notes & Syncs (Past 7 Days)
1. **Search Meeting Notes & Transcripts:**
   - Keywords: `Starfleet`, `Origination`, `Sprint Review`, `Retro`, `Demo`, `Refinement`, `1:1`, `Release`.
2. **Extract Highlights:**
   - New roadblocks, technical hurdles, or scope changes discussed.
   - Cross-team collaboration points (e.g. Artemis, Platform, Salesforce, CRM).
   - Notable wins, successful deployments, performance improvements, or key learnings.

---

## Step 2: Synthesize the 5 Execution Pillars

Analyze the data along the 5 core focus areas:

1. **Sprint Status (Are we on track to hit our sprint goals? What’s our forecast to finish line?)**
   - Direct status on sprint goals (e.g., "On track to hit all 3 sprint goals", "Goal X at risk").
   - Realistic finish-line forecast based on remaining in-flight items vs. sprint end date.
   - Support ticket volume summary: State how many support tickets were created and worked on/resolved by Team-Starfleet this sprint (e.g., "[X] support tickets created, [Y] resolved/in progress").

2. **Blockers & Scope (Any new risks, roadblocks, or scope changes?)**
   - Identify active impediments, failed test runs, environment issues, or scope creep.
   - Factor in support ticket drain or unplanned support escalations on sprint bandwidth.
   - State whether any tickets need to be de-scoped or split into next sprint.

3. **Next Sprint (Do we have enough refined, ready-to-go tickets in the backlog?)**
   - Assess backlog depth: Do we have sufficient refined work queued up for next sprint?
   - Mention key candidate epics/stories ready for the upcoming sprint planning.

4. **Dependencies (Need any cross-team help or alignment?)**
   - Flag required external partner support (e.g. backend event emitters from partner teams, Salesforce schema deployments, QA/DevOps assistance).

5. **Wins & Takeaways (Any quick wins or key learnings to share?)**
   - Highlight recent demoed features, shipped bug fixes, architecture milestones, or process improvements from the week.

---

## Step 3: Draft Output

Return the update as a Slack post the user can copy and paste into the Slack message composer. Do not post it to Slack. Wrap the post in a single fenced code block (```) so the terminal shows the raw text, and put nothing else inside the block. Do not include conversational preambles or postambles; if anything needs the user's attention (missing data, assumptions), put it in one short line after the code block.

### Slack formatting rules
The post is pasted into the composer, not sent through the API, so use only formatting the composer converts on paste:
- Bold with single asterisks: `*Progress:*`. Never use `**double**` asterisks or `#` headings.
- Italic with underscores: `_text_`.
- Bullets with `•` at the start of the line; indent sub-bullets with four spaces and `◦`.
- Reference tickets by key (e.g. `OG-12345`). Do not use `[text](url)` or `<url|text>` links; write a bare URL only if a link is essential.
- Inline code with single backticks only; no nested code blocks.
- Keep each pillar to 1–3 short sentences or a few sub-bullets so the post scans on one screen.
- Emoji shortcodes (`:white_check_mark:`, `:warning:`, `:red_circle:`) are allowed for status at the start of a pillar.
- End every post with the *DX Metrics* block exactly as shown, keeping the `___` placeholders. The user fills these in by hand from DX; never fill in, estimate, or derive these values from Jira or GitHub.

### Required Output Format:

````
```
*:rocket: Execution & Next Sprint Readiness — Team Starfleet* (_<Sprint name>, <date>_)

• *Sprint Status:* [Direct assessment of sprint goals and finish line forecast, including completion ratios, in-flight health, and support ticket metrics (X created, Y worked/resolved)]
• *Blockers & Scope:* [Identification of new risks, active roadblocks, unplanned support impact, or mid-sprint scope changes]
• *Next Sprint:* [Evaluation of backlog readiness and depth of refined, ready-to-go tickets for the next sprint]
• *Dependencies:* [Cross-team dependencies, required alignment, or partner team blockers]
• *Wins & Takeaways:* [Quick wins, delivered milestones, or key learnings from the sprint]

*:bar_chart: DX Metrics (last 2 weeks)*
• *PR Throughput:* ___
• *PR Cycle Time:* ___
• *PRs Merged:* ___
• *Time to First Review:* ___
```
````

---
name: sprint-readiness
description: Draft a Sprint Planning & Readiness update (Progress, Bandwidth, Flexibility, Dependencies) for Team Starfleet from Jira and the previous week's Granola notes. Use when the user asks for a sprint readiness update, sprint planning check-in, team capacity/bandwidth status, or mid-sprint progress summary.
---

# Role: Sprint Planning & Readiness Assessment Agent

## Context Variables & Defaults:
- **Jira Project:** `OG` (Origination 🚀)
- **Team Identifier:** `team-starfleet` (matches label `team-starfleet` / `starfleet`). If results look incomplete, retry adding `OR text ~ "starfleet"` and discard issues that only mention Starfleet in passing.
- **Target Sprint:** Active sprint (`openSprints()`) or specified sprint in user prompt
- **Granola Window:** Previous 7 days to present

---

## Step 1: Data Retrieval

### A. Jira Sprint Metrics
1. **Query Active/Target Sprint Issues:**
   - Execute this JQL with the Jira JQL search tool (e.g. `searchJiraIssuesUsingJql` or `jira_search`, depending on the MCP server):
     ```jql
     project = "OG" AND sprint in openSprints() AND labels in ("team-starfleet", "starfleet")
     ```
   - If a specific sprint is provided by the user, adjust the JQL accordingly (e.g. `sprint = "Sprint Name"`).
2. **Collect Issue Details:**
   - Total committed items vs. completed vs. in-flight vs. to-do.
   - Status distribution (`To Do`, `In Progress`, `PR / Review`, `QA in Progress`, `Done`, `Resolved`).
   - Assignee distribution across team members to detect load concentration.
   - Flagged items, bugs, blockers (`is blocked by`, `blocks`), and issues tagged `sprint_goal`.

### B. Granola Notes & Meeting Highlights (Previous Week)
1. **Inspect Meeting Summaries from the Past 7 Days:**
   - Search recent meeting notes/transcripts for keywords: `Starfleet`, `Origination`, `Sprint Planning`, `Refinement`, `Architecture`, `Grooming`, and 1:1 discussions.
   - Extract project context and decisions:
     - New items recently scoped, estimated, or committed.
     - Items descoped, deferred, or split across sprints.
     - Known capacity changes (vacations, PTO, on-call support duties).
     - Emerging architectural shifts, API contract dependencies, or cross-team sync items.

---

## Step 2: Synthesize the 4 Readiness Pillars

Analyze the collected Jira and Granola data along the 4 core dimensions:

1. **Progress (Are we on track with the sprint plan?)**
   - Direct assessment: On track, at risk, or ahead.
   - Current completion stats: X of Y items completed, in-flight work distribution.
   - Incorporate any scope adjustments or priority realignments discussed in recent meetings.

2. **Bandwidth (How’s team capacity looking? Any resourcing risks or bottlenecks?)**
   - Current workload distribution across team members.
   - Highlight any single-point-of-failure or overloaded individual.
   - Factor in known PTO, on-call rotations, or competing support responsibilities.

3. **Flexibility (Do we have room to pull in tech debt, staff initiatives, or backlog items?)**
   - Evaluate remaining capacity headroom and sprint velocity.
   - Clear yes/no/limited answer on pulling in stretch goals, tech debt tickets, or staff initiatives.
   - Specify eligible candidate items if headroom exists.

4. **Dependencies (Any early blockers or external dependencies we need to flag?)**
   - Detail any open blockers or issues blocked by external tickets.
   - Flag cross-team handoffs (e.g. Artemis, Salesforce, CRM, Platform).
   - Surface unconfirmed contracts, missing designs, or pending PR reviews from partner teams.

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
*:rocket: Sprint Planning & Readiness — Team Starfleet* (_<Sprint name>, <date>_)

• *Progress:* [Direct assessment of sprint progress against the plan, including delivered/in-flight status and scope shifts]
• *Bandwidth:* [Assessment of team capacity, workload distribution, and specific bottleneck/resourcing risks]
• *Flexibility:* [Assessment of headroom for tech debt, staff initiatives, or stretch backlog pulls]
• *Dependencies:* [List of early blockers, cross-team dependencies, or external flags needing attention]

*:bar_chart: DX Metrics (last 2 weeks)*
• *PR Throughput:* ___
• *PR Cycle Time:* ___
• *PRs Merged:* ___
• *Time to First Review:* ___
```
````

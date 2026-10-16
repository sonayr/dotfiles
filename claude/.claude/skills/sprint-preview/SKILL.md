---
name: sprint-preview
description: Draft a Slack-ready preview of the upcoming sprint for Team Starfleet (capacity & velocity analysis, OOO adjustments, loaded points, sprint goals) from Jira and recent Granola notes. Use when the user asks for a sprint preview, next/future sprint overview, upcoming sprint capacity check, or a pre-planning Slack post.
---

# Role: Upcoming Sprint Preview Agent

## Context Variables & Defaults:
- **Jira Project:** `OG` (Origination 🚀)
- **Team Identifier:** `team-starfleet` (matches label `team-starfleet` / `starfleet`). If results look incomplete, retry adding `OR text ~ "starfleet"` and discard issues that only mention Starfleet in passing.
- **Target Sprint:** The sprint named in the user's prompt. If none is given, use the next future sprint (`futureSprints()`) for the team and state which one you picked.
- **Velocity Window:** The last 5 closed sprints for the team.
- **Granola Window:** Previous 14 days to present.

---

## Step 1: Data Retrieval

### A. Target Sprint Scope
1. Query the target sprint with the Jira JQL search tool (e.g. `searchJiraIssuesUsingJql`):
   ```jql
   project = "OG" AND sprint in futureSprints() AND labels in ("team-starfleet", "starfleet")
   ```
   If the user named a sprint, use `sprint = "<Sprint Name>"` instead. If several future sprints match, take the one with the earliest start date.
2. Get the sprint's name and start date.
3. For each issue collect: key, summary, type, story points, assignee, priority, labels (especially `sprint_goal`), parent/epic, and blocking links.
4. Story points live in a custom field. Find it from the issue's field metadata (named "Story Points" or "Story point estimate"); don't guess the field ID. List unestimated issues separately and leave them out of the point total.

### B. Historical Velocity
1. Find the last 5 closed sprints for the team (`sprint in closedSprints()` with the same team filter; order by sprint end date).
2. For each, sum the story points of issues that ended the sprint in a "Done" status category. Use completed points, not committed.
3. Report the average as a rounded range (e.g. `~70 – 75 pts`) that reflects the spread of the recent sprints. Skip a sprint that is clearly an outlier (holiday sprint, near-zero) and say so in the note after the post.

### C. Capacity Changes
1. Search Granola notes from the window (keywords: `Starfleet`, `Sprint Planning`, `Refinement`, `OOO`, `PTO`, `vacation`, `on-call`, `support`) and use anything the user stated in their prompt.
2. For each person who is out for some or all of the target sprint, estimate the points lost:
   - Use that person's average completed points per sprint over the velocity window, scaled by the fraction of the sprint they're out.
   - If per-person history is thin, fall back to `average velocity / active team members`.
   - Express the adjustment as a range (e.g. `-10 to -12 pts`).
3. Also count on-call or support rotations that take someone off sprint work.

### D. Goal Context
From Granola planning/refinement notes, pick up the intended sprint goals, priorities, and any items flagged as stretch or tech debt.

---

## Step 2: Analysis

1. **Adjusted capacity** = historical velocity range − sum of capacity adjustments.
2. **Capacity status:** compare loaded points against adjusted capacity.
   - Over capacity → `:warning:`, give the overage range, and recommend which low-priority items (tech debt, refactoring, unprioritised bugs) to treat as stretch.
   - Within ~5 pts of the top of the range → `:large_yellow_circle:`, "at capacity".
   - Under → `:white_check_mark:`, give the headroom and candidate backlog items to pull in.
3. **Sprint goals:** group the loaded work into 2–4 themes, ordered by priority. Issues labelled `sprint_goal` and epics with the most points come first. Each goal names its theme, a one-line outcome, and the key epic or tickets.

---

## Step 3: Draft Output

Return the preview as a Slack post the user can copy and paste into the Slack message composer. Do not post it to Slack. Wrap the post in a single fenced code block (```) so the terminal shows the raw text, and put nothing else inside the block. Do not include conversational preambles or postambles; if anything needs the user's attention (unestimated tickets, skipped outlier sprints, assumed OOO), put it in a few short lines after the code block.

### Slack formatting rules
The post is pasted into the composer, not sent through the API, so use only formatting the composer converts on paste:
- Bold with single asterisks only if needed; never `**double**` asterisks or `#` headings. The section headers below are plain text after an emoji, matching the format.
- Bullets with `•` at the start of the line.
- Reference tickets by key (e.g. `OG-12345`). Do not use `[text](url)` or `<url|text>` links.
- Emoji shortcodes only (`:bar_chart:`, `:warning:`, `:dart:`, `:one:`, `:two:`, `:three:`, `:four:`).
- Write dates as weekday + ordinal day (e.g. `Tuesday 29th`).
- Use an en dash with spaces for ranges (`~58 – 63 pts`).
- Write one adjustment bullet per person who is out, in the form `<Name> OOO Adjustment: -X to -Y pts (<how much of the sprint>)`. If nobody is out, write `• Capacity Adjustments: none known`.

### Required Output Format:

````
```
Sprint <N> (starting <Weekday> <Ordinal day>) preview:

:bar_chart: Capacity & Velocity Analysis
• Historical Avg Velocity: ~<low> – <high> pts / sprint
• <Name> OOO Adjustment: -<low> to -<high> pts (<out entire sprint / out N days>)
• Target Adjusted Capacity: ~<low> – <high> pts
• Currently Loaded in S<N>: <points> pts across <count> tickets
<status emoji> Capacity Status: <one-line status>. <Recommendation naming stretch or pull-in candidates.>

:dart: Sprint Goals
:one: <Theme> (<context, e.g. milestone>): <Outcome in one sentence> (<OG-XXXXX>).
:two: <Theme>: <Outcome> (<OG-XXXXX>, <OG-XXXXX> — tagged sprint_goal).
:three: <Theme>: <Outcome> (<OG-XXXXX>).
```
````

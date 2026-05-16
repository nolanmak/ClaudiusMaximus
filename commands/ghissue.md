Create a GitHub issue using `gh issue create` (and follow-up `gh` commands as needed for fields not exposed by the create flags). Follow these rules exactly:

## Cycles (Iterations)
- GitHub Iterations are our weekly cycles.
- **Current cycle: Cycle 24 — week of 4/27 through 5/3.**
- If the issue is `frontend`, add it to the current cycle.

## Milestones
Pick exactly one. If unclear, ask before creating.
- **Scheduled Work** — planned into cycles, no larger release milestone yet. **Default for `frontend` issues.**
- **Backlog** — valid work we may want later, not currently planned.
- **Triage: Bugs & Feedback** — default landing zone for new issues when nothing else fits.
- **Private Beta** — closed beta with trusted users.
- **Public Beta** — broader external release work.
- **Audio** — temporary grouping for audio-related work.
- No milestone = needs discussion. Do not leave milestone empty unless the user explicitly asks for triage.

## Required metadata
- **Estimate** (t-shirt size): one of `XS`, `S`, `M`, `L`, `XL`. Ask if not obvious.
- **Type**: one of `Bug`, `Feature`, `Task`.
- **Labels**:
  - Include an **App Phase** label (e.g. `pre-production`, `plan`, `production`).
  - If `frontend`, also include a **component** tag matching the affected area.
  - Avoid inventing new labels — if unsure, list candidates and ask.

## Frontend rule (apply when `frontend` label is set)
1. Add a corresponding **component** label.
2. Assign **`nolanmak`**.
3. Add to the **current cycle** (Cycle 24).
4. Set milestone to **Scheduled Work**.

## Workflow
1. Confirm the title, body, type, milestone, estimate, labels (incl. App Phase + component if frontend), assignee, and cycle with the user before creating — show the planned values back as a checklist.
2. Create the issue with `gh issue create` setting what the flags support (`--title`, `--body`, `--label`, `--assignee`, `--milestone`).
3. Set type, estimate (size), and iteration via `gh` project/field commands or the GraphQL API as needed (these are not on `gh issue create`).
4. Print the resulting issue URL.

Now proceed: ask for the title and a short description if not provided, then walk through the checklist.

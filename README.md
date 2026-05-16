# ClaudiusMaximus

A reference catalog of the **general** Claude Code slash commands (skills)
available in this environment, documented automatically.

> Slash commands are invoked by typing `/<name>` in the Claude Code prompt.
> Each one maps to a "skill" — a packaged capability or workflow.
>
> Project/Orchid-specific commands are intentionally excluded — this lists
> general-purpose commands only.

## Command Catalog

| Command | Purpose |
|---|---|
| `/intercept` | Claude Intercept — intercept and inspect requests/responses. |
| `/regression-test-plan` | Analyze all changes on the current branch, find regression test gaps, and plan fixes. |
| `/consensus` | Gather consensus from multiple AI models on a topic, decision, or code review. |
| `/coderabbit` | Run a CodeRabbit-style automated code review. |
| `/PRReview` | PR Remediation Swarm V1 — multi-agent PR review and remediation. |
| `/invoice` | Generate an invoice summary of work done for a specified time period. |
| `/ghissue` | Create a GitHub issue using `gh issue create` (plus follow-up `gh` commands for fields). |
| `/GenPRText` | Generate a PR title and description based on all changes on the current branch. |
| `/swarm` | Raise an agent team of ten or more to tackle a large task in parallel. |
| `/runtest` | Run the complete test and lint suite, fixing ALL failures regardless of relevance. |
| `/caveman` | Caveman Mode. |
| `/checkresources` | Check resources. |
| `/update-config` | Configure the Claude Code harness via `settings.json` (permissions, env vars, hooks). |
| `/keybindings-help` | Customize keyboard shortcuts / rebind keys in `~/.claude/keybindings.json`. |
| `/simplify` | Review changed code for reuse, quality, and efficiency, then fix issues found. |
| `/fewer-permission-prompts` | Scan transcripts and add a prioritized Bash/MCP allowlist to project settings. |
| `/loop` | Run a prompt or slash command on a recurring interval (e.g. `/loop 5m /foo`). |
| `/schedule` | Create, update, list, or run scheduled remote agents (cron routines). |
| `/claude-api` | Build, debug, optimize, and migrate Claude API / Anthropic SDK apps. |
| `/init` | Initialize a new `CLAUDE.md` file with codebase documentation. |
| `/review` | Review a pull request. |
| `/security-review` | Complete a security review of the pending changes on the current branch. |

## Categories

### Code Review & Quality
- `/review` — Pull request review
- `/coderabbit` — CodeRabbit-style automated review
- `/security-review` — Security review of pending branch changes
- `/PRReview` — Multi-agent PR remediation swarm
- `/simplify` — Refactor changed code for reuse/quality/efficiency
- `/consensus` — Multi-model consensus on decisions/reviews

### Testing
- `/runtest` — Full test + lint suite, fix all failures
- `/regression-test-plan` — Find regression gaps and plan fixes

### Git / GitHub
- `/ghissue` — Create a GitHub issue
- `/GenPRText` — Generate PR title + description

### Automation & Orchestration
- `/swarm` — Raise a 10+ agent team
- `/loop` — Recurring interval execution
- `/schedule` — Scheduled remote cron agents

### Configuration
- `/update-config` — Harness `settings.json` configuration
- `/keybindings-help` — Keyboard shortcut customization
- `/fewer-permission-prompts` — Auto-generate permission allowlist
- `/init` — Bootstrap `CLAUDE.md`

### Development
- `/claude-api` — Claude API / Anthropic SDK app development
- `/intercept` — Request/response interception

### Misc
- `/caveman` · `/checkresources` · `/invoice`

---

_Generated on 2026-05-15. General-purpose commands only; project/Orchid-specific skills excluded._

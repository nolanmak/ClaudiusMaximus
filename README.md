# ClaudiusMaximus

A drop-in pack of **general-purpose Claude Code slash commands**. Every command
is a full, verbatim prompt file — copy them into `~/.claude/commands/` and they
work immediately. No editing required (except a couple noted below).

Project/Orchid-specific commands are intentionally excluded.

---

## ⚡ Install (pick one)

### Option A — One script
```bash
git clone https://github.com/nolanmak/ClaudiusMaximus.git
cd ClaudiusMaximus && ./install.sh
```

Safe to re-run. It checks what's already installed and skips anything that's up to date, already comes from a plugin, or that you manage yourself (a symlink or its own git checkout). Anything it replaces is backed up to `~/.claude/backups/claudiusmaximus/`. Run `./install.sh --dry-run` to see what it would do first.

### Option B — Manual
```bash
cp commands/*.md ~/.claude/commands/
mkdir -p ~/.claude/skills/intercept && cp skills/intercept/SKILL.md ~/.claude/skills/intercept/
```

### Option C — Feed it to your agent
Open [`INSTALL.md`](INSTALL.md) and paste the whole thing into Claude Code.
It installs everything for you and explains what to customize.

---

## 📂 Commands

Each file in [`commands/`](commands/) **is** the full slash-command prompt — the
exact text Claude runs when you type `/<name>`.

| Command | File | What it does |
|---|---|---|
| `/caveman` | [caveman.md](commands/caveman.md) | Ultra-compressed "smart caveman" output mode (~75% fewer tokens). Levels: `lite`/`full`/`ultra`. |
| `/checkresources` | [checkresources.md](commands/checkresources.md) | Deep macOS resource audit (CPU/RAM/zombies/ports) with kill-ready recommendations. |
| `/coderabbit` | [coderabbit.md](commands/coderabbit.md) | Run CodeRabbit CLI review on uncommitted changes. |
| `/consensus` | [consensus.md](commands/consensus.md) | Multi-model consensus (Gemini 3 Pro, Grok 4, Opus 4.5, Codex GPT5.2). |
| `/GenPRText` | [GenPRText.md](commands/GenPRText.md) | Generate PR title + description from the branch diff. |
| `/invoice` | [invoice.md](commands/invoice.md) | Build an invoice summary of merged PRs for a date range. ⚙️ |
| `/PRReview` | [PRReview.md](commands/PRReview.md) | PR Remediation Swarm — 7-role multi-agent review→fix→ship pipeline. |
| `/regression-test-plan` | [regression-test-plan.md](commands/regression-test-plan.md) | Find regression-test gaps in branch changes and plan fixes. |
| `/swarm` | [swarm.md](commands/swarm.md) | Raise a persistent 10+ agent team in delegate mode. |

### Skills

| Skill | File | What it does |
|---|---|---|
| `/intercept` | [skills/intercept/SKILL.md](skills/intercept/SKILL.md) | MITM proxy assistant for capturing/analyzing HTTP(S) traffic. ⚙️ |

### Shell aliases

[`aliases/claude.sh`](aliases/claude.sh) adds two launchers that drop you
straight into **ultracode** mode (xhigh effort + standing dynamic-workflow
orchestration) by auto-submitting `/effort ultracode` as the first turn:

| Alias | Command |
|---|---|
| `claudelol` | `claude --dangerously-skip-permissions "/effort ultracode"` |
| `f` | same as `claudelol`, one keystroke |

`install.sh` copies the file to `~/.claude/claudiusmaximus-aliases.zsh` and adds a
`source` line to your `~/.zshrc` (idempotent, backs up first). By hand:
`echo 'source ~/.claude/claudiusmaximus-aliases.zsh' >> ~/.zshrc`.

> **Heads up:** ultracode and `--remote-control` are mutually exclusive — a Remote
> Control session caps effort at xhigh and rejects ultracode, and its boot prompt
> isn't auto-submitted. These aliases omit `--remote-control` on purpose. For a
> drive-from-phone session, launch `claude --remote-control` separately (xhigh,
> not ultracode).

### Prompts

[`prompts/`](prompts/) holds the verbatim user prompts that produced the
non-slash artifacts in this repo (e.g. the aliases). The slash-command prompts
themselves already live in [`commands/`](commands/).

⚙️ = contains user/machine-specific values you should tweak (see below).

---

## ⚙️ Customize before relying on these

These files work as-is but reference personal/machine config:

- **`commands/invoice.md`** — filters git log by author `nolanmak`. Change to your
  git author name.
- **`commands/coderabbit.md`** — expects the CodeRabbit CLI at `$HOME/.local/bin/coderabbit`.
- **`skills/intercept/SKILL.md`** — hardcodes the absolute path
  `/Users/nolanmakatche/claude_intercept`. Repoint to wherever you install the tool.

The rest (`caveman`, `checkresources`, `consensus`, `GenPRText`, `PRReview`,
`regression-test-plan`, `swarm`) are portable as-is.

---

## How Claude Code slash commands work

- A file at `~/.claude/commands/<name>.md` becomes the `/<name>` command.
- Its entire contents are injected as the prompt when invoked.
- `$ARGUMENTS` in the file is replaced with whatever you type after the command.
- YAML frontmatter (`description`, `allowed-tools`, `argument-hint`) is optional
  metadata — see `regression-test-plan.md` for an example.
- Skills live at `~/.claude/skills/<name>/SKILL.md` and are invoked the same way.

---

_General-purpose commands only. Project/Orchid-specific skills excluded by design._

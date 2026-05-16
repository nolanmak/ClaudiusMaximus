# Agent Setup Prompt

Copy everything in the code block below and paste it into Claude Code (or any
coding agent with shell + file access). It will install the whole pack and tell
you what to customize.

---

```
Install the ClaudiusMaximus slash-command pack into my Claude Code setup.

1. Clone the repo if it isn't already local:
   git clone https://github.com/nolanmak/ClaudiusMaximus.git
   (skip if a ClaudiusMaximus directory already exists — just cd into it)

2. Copy every command into my user commands directory:
   mkdir -p ~/.claude/commands
   cp ClaudiusMaximus/commands/*.md ~/.claude/commands/

3. Copy the intercept skill:
   mkdir -p ~/.claude/skills/intercept
   cp ClaudiusMaximus/skills/intercept/SKILL.md ~/.claude/skills/intercept/SKILL.md

4. List what got installed: ls ~/.claude/commands

5. Then open these files and adapt the machine/user-specific values to MY
   environment, asking me for anything you can't infer:
   - ~/.claude/commands/ghissue.md  -> my GitHub project's cycle name, milestone
     names, and assignee (currently hardcoded to "nolanmak" / "Cycle 24")
   - ~/.claude/commands/invoice.md  -> my git author name (currently "nolanmak")
   - ~/.claude/commands/runtest.md  -> my project's actual test/lint scripts
   - ~/.claude/commands/coderabbit.md -> path to my coderabbit CLI binary
   - ~/.claude/skills/intercept/SKILL.md -> the absolute path where I install
     claude_intercept (currently /Users/nolanmakatche/claude_intercept)

6. Confirm by telling me which slash commands are now available and which ones
   you edited for me.

Do not modify these (they are portable as-is): caveman, checkresources,
consensus, GenPRText, PRReview, regression-test-plan, swarm.
```

---

After it finishes, restart Claude Code (or start a new session) and the commands
appear when you type `/`.

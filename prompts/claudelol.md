# `claudelol` alias

Verbatim prompts that produced [`aliases/claude.sh`](../aliases/claude.sh).

---

## 1. Original

> claude --dangerously-skip-permissions  --remote-control
> make this an alias so i dont need to type claudelol shud be that cmd on my laptop

```sh
alias claudelol='claude --dangerously-skip-permissions --remote-control'
```

## 2. Ultracode update (current)

> update my alias claudelol so it also starts in ultracode mode also pls add an
> alias that is identical to claudelol but is just one letter f so i dont need to
> type that bs

```sh
alias claudelol='claude --dangerously-skip-permissions "/effort ultracode"'
alias f='claude --dangerously-skip-permissions "/effort ultracode"'
```

There is no `--ultracode`/`--effort ultracode` flag — `--effort` only accepts
`low|medium|high|xhigh|max`, and the `CLAUDE_CODE_EFFORT_LEVEL` env var ignores
`ultracode`. Ultracode is session-only (`xhigh` effort + standing
dynamic-workflow orchestration), set solely by the `/effort ultracode` slash
command. Passing it as the positional prompt auto-submits it as the first turn,
so the session boots straight into ultracode.

**The catch (verified under a real PTY):** ultracode and `--remote-control` are
mutually exclusive. A Remote Control session runs against a remote process that
caps effort at `xhigh` and rejects ultracode (*"session-scoped — won't reach the
remote process"*), and its boot prompt isn't auto-submitted. So the ultracode
aliases drop `--remote-control`. For a drive-from-claude.ai / phone session, run
`claude --remote-control` separately — it will be `xhigh`, not ultracode.

Drop into `~/.zshrc` (or `~/.bashrc`), then `source ~/.zshrc` — or open a new
shell — and `claudelol` (or `f`) launches Claude Code straight into ultracode.

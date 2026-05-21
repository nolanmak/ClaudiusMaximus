# `claudelol` alias

Verbatim prompt that produced [`aliases/claude.sh`](../aliases/claude.sh).

---

> claude --dangerously-skip-permissions  --remote-control
> make this an alias so i dont need to type claudelol shud be that cmd on my laptop

---

## Result

```sh
alias claudelol='claude --dangerously-skip-permissions --remote-control'
```

Drop into `~/.zshrc` (or `~/.bashrc`), then `source ~/.zshrc` — or open a new
shell — and `claudelol` launches Claude Code with permission prompts disabled
and the remote-control channel open.

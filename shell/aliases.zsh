# ClaudiusMaximus shell aliases
#
# The installer copies this to ~/.claude/claudiusmaximus-aliases.zsh and adds a
# `source` line to your shell rc. To wire it up by hand instead:
#   echo 'source ~/.claude/claudiusmaximus-aliases.zsh' >> ~/.zshrc
#
# ── claudelol / f ────────────────────────────────────────────────────────────
# Launch Claude Code straight into ULTRACODE mode — xhigh effort + standing
# dynamic-workflow orchestration — by auto-submitting the `/effort ultracode`
# slash command as the first turn. (`f` is just a one-keystroke copy.)
#
# Why no --remote-control: ultracode and Remote Control are mutually exclusive.
# A Remote Control session runs against a remote process that caps effort at
# xhigh and rejects ultracode ("session-scoped — won't reach the remote
# process"), and the boot prompt isn't auto-submitted there. So these aliases
# intentionally omit it. If you need to drive a session from claude.ai / your
# phone, start a separate `claude --remote-control` session — it will run at
# xhigh, not ultracode.
alias claudelol='claude --dangerously-skip-permissions "/effort ultracode"'
alias f='claude --dangerously-skip-permissions "/effort ultracode"'

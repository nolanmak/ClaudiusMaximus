# Source this from your ~/.zshrc (or ~/.bashrc) to enable the aliases.
# The installer copies this to ~/.claude/claudiusmaximus-aliases.zsh and wires
# the source line for you; to do it by hand:
#   echo 'source ~/.claude/claudiusmaximus-aliases.zsh' >> ~/.zshrc

# claudelol / f — launch Claude Code straight into ULTRACODE mode: xhigh effort
# + standing dynamic-workflow orchestration, by auto-submitting the
# `/effort ultracode` slash command as the first turn. `f` is a one-keystroke
# copy of claudelol.
#
# Why no --remote-control: ultracode and Remote Control are mutually exclusive.
# A Remote Control session runs against a remote process that caps effort at
# xhigh and rejects ultracode ("session-scoped — won't reach the remote
# process"), and its boot prompt isn't auto-submitted. So these aliases omit it.
# For a drive-from-claude.ai / phone session, run `claude --remote-control`
# separately — it will be xhigh, not ultracode.
alias claudelol='claude --dangerously-skip-permissions "/effort ultracode"'
alias f='claude --dangerously-skip-permissions "/effort ultracode"'

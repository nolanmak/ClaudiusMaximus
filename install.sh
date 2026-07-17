#!/usr/bin/env bash
# ClaudiusMaximus installer — copies the general slash-command pack into
# ~/.claude/commands and ~/.claude/skills. Idempotent. Backs up collisions.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD_SRC="$SCRIPT_DIR/commands"
SKILL_SRC="$SCRIPT_DIR/skills"
ALIAS_SRC="$SCRIPT_DIR/aliases/claude.sh"
MD_SRC="$SCRIPT_DIR/CLAUDE.md"
CMD_DST="$HOME/.claude/commands"
SKILL_DST="$HOME/.claude/skills"
ALIAS_DST="$HOME/.claude/claudiusmaximus-aliases.zsh"
MD_DST="$HOME/.claude/CLAUDE.md"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "ClaudiusMaximus → installing to ~/.claude"
mkdir -p "$CMD_DST" "$SKILL_DST"

backup_if_exists() {
  if [ -e "$1" ]; then
    cp -p "$1" "$1.bak-$STAMP"
    echo "  backed up existing $(basename "$1") → $(basename "$1").bak-$STAMP"
  fi
}

# Commands
for f in "$CMD_SRC"/*.md; do
  name="$(basename "$f")"
  backup_if_exists "$CMD_DST/$name"
  cp "$f" "$CMD_DST/$name"
  echo "  installed /$(basename "$name" .md)"
done

# Skills (one dir per skill)
for d in "$SKILL_SRC"/*/; do
  name="$(basename "$d")"
  mkdir -p "$SKILL_DST/$name"
  backup_if_exists "$SKILL_DST/$name/SKILL.md"
  cp "$d/SKILL.md" "$SKILL_DST/$name/SKILL.md"
  echo "  installed skill /$name"
done

# Global CLAUDE.md (user-level conventions applied to every project)
if [ -f "$MD_SRC" ]; then
  backup_if_exists "$MD_DST"
  cp "$MD_SRC" "$MD_DST"
  echo "  installed CLAUDE.md (global conventions)"
fi

# Shell aliases (claudelol / f -> launch straight into ultracode mode).
# Copy the aliases file into ~/.claude and source it from the user's shell rc.
# Idempotent: a marker guards against duplicate source lines on re-runs.
if [ -f "$ALIAS_SRC" ]; then
  backup_if_exists "$ALIAS_DST"
  cp "$ALIAS_SRC" "$ALIAS_DST"
  echo "  installed aliases (claudelol, f) -> $ALIAS_DST"

  # Prefer ~/.zshrc, fall back to ~/.bashrc.
  RC=""
  if [ -f "$HOME/.zshrc" ]; then RC="$HOME/.zshrc"
  elif [ -f "$HOME/.bashrc" ]; then RC="$HOME/.bashrc"
  fi
  MARKER="# ClaudiusMaximus aliases"
  if [ -n "$RC" ]; then
    if grep -qF "$MARKER" "$RC"; then
      echo "  shell rc already sources the aliases ($RC) — left untouched"
    else
      backup_if_exists "$RC"
      printf '\n%s\nsource "%s"\n' "$MARKER" "$ALIAS_DST" >> "$RC"
      echo "  wired aliases into $RC (run: source $RC)"
    fi
  else
    echo "  no ~/.zshrc or ~/.bashrc found — add this line to your shell rc:"
    echo "      source \"$ALIAS_DST\""
  fi
fi

echo
echo "Done. Restart Claude Code or start a new session, then type / to see them."
echo "NOTE: ghissue, invoice, runtest, coderabbit, and the intercept skill"
echo "contain machine/user-specific values — see README.md → Customize."

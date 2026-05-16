#!/usr/bin/env bash
# ClaudiusMaximus installer — copies the general slash-command pack into
# ~/.claude/commands and ~/.claude/skills. Idempotent. Backs up collisions.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD_SRC="$SCRIPT_DIR/commands"
SKILL_SRC="$SCRIPT_DIR/skills"
CMD_DST="$HOME/.claude/commands"
SKILL_DST="$HOME/.claude/skills"
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

echo
echo "Done. Restart Claude Code or start a new session, then type / to see them."
echo "NOTE: ghissue, invoice, runtest, coderabbit, and the intercept skill"
echo "contain machine/user-specific values — see README.md → Customize."

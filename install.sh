#!/usr/bin/env bash
# ClaudiusMaximus installer — copies the general slash-command pack into
# ~/.claude/commands, skills into ~/.claude/skills (and Codex skills into
# ~/.codex/skills if the repo ships any), plus the global ~/.claude/CLAUDE.md.
#
# Safe to re-run. For each item it checks what's already there first:
#   - identical copy already installed      -> skipped
#   - same skill already comes from a plugin -> skipped (no duplicate skill)
#   - same skill installed under another dir -> skipped
#   - folder you manage yourself (a symlink
#     or its own git checkout)              -> skipped, never overwritten
#   - older/different copy                  -> backed up, then replaced
# Backups go to ~/.claude/backups/claudiusmaximus/<timestamp>/, outside the
# skills folders, so Claude and Codex never load a backup as a second skill.
#
#   ./install.sh            install / update
#   ./install.sh --dry-run  show what would happen, change nothing
set -euo pipefail

DRY_RUN=0
case "${1:-}" in
  --dry-run|-n) DRY_RUN=1 ;;
  "") ;;
  *) echo "usage: $0 [--dry-run]" >&2; exit 2 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMD_SRC="$SCRIPT_DIR/commands"
ALIAS_SRC="$SCRIPT_DIR/aliases/claude.sh"
MD_SRC="$SCRIPT_DIR/CLAUDE.md"
MD_DST="$HOME/.claude/CLAUDE.md"
CMD_DST="$HOME/.claude/commands"
ALIAS_DST="$HOME/.claude/claudiusmaximus-aliases.zsh"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="$HOME/.claude/backups/claudiusmaximus/$STAMP"

INSTALLED=0; UPDATED=0; SKIPPED=0

run() { if [ "$DRY_RUN" = 1 ]; then echo "    (dry run) $*"; else "$@"; fi; }

# Move or copy something into the backup folder, keeping its relative layout.
backup() { # backup <path> <subdir> [copy]
  local src="$1" sub="$2" mode="${3:-move}"
  run mkdir -p "$BACKUP_ROOT/$sub"
  if [ "$mode" = copy ]; then run cp -pR "$src" "$BACKUP_ROOT/$sub/"
  else run mv "$src" "$BACKUP_ROOT/$sub/"; fi
  echo "    backed up old copy -> ${BACKUP_ROOT/#"$HOME"/\~}/$sub/$(basename "$src")"
}

same_content() { diff -rq -x .git -x .DS_Store "$1" "$2" >/dev/null 2>&1; }

# The `name:` from a SKILL.md's frontmatter (falls back to the dir name).
skill_name() {
  local n
  n="$(awk '/^---/{c++; next} c==1 && /^name:/{sub(/^name:[ \t]*/,""); gsub(/["\x27]/,""); print; exit}' "$1/SKILL.md" 2>/dev/null || true)"
  echo "${n:-$(basename "$1")}"
}

# Root folders of plugins that are installed for each app.
claude_plugin_roots() {
  local f="$HOME/.claude/plugins/installed_plugins.json"
  [ -f "$f" ] || return 0
  grep -o '"installPath"[[:space:]]*:[[:space:]]*"[^"]*"' "$f" | sed 's/.*"\([^"]*\)"$/\1/'
}
codex_plugin_roots() {
  local d="$HOME/.codex/plugins/cache"
  [ -d "$d" ] || return 0
  find "$d" -mindepth 3 -maxdepth 3 -type d 2>/dev/null
}

# Prints the plugin dir that already ships this skill, if any.
plugin_providing() { # plugin_providing <app> <skill-name>
  local app="$1" name="$2" root hit
  while IFS= read -r root; do
    [ -d "$root" ] || continue
    hit="$(find "$root" -path "*/skills/$name/SKILL.md" -not -path "*/node_modules/*" 2>/dev/null | head -1)"
    if [ -n "$hit" ]; then echo "$root"; return 0; fi
  done < <("${app}_plugin_roots")
  return 1
}

# Prints another dir in <dst> whose SKILL.md declares the same name, if any.
same_name_elsewhere() { # same_name_elsewhere <dst> <dirname> <skill-name>
  local dst="$1" dir="$2" name="$3" other
  for other in "$dst"/*/; do
    other="${other%/}"
    [ -f "$other/SKILL.md" ] || continue
    [ "$(basename "$other")" = "$dir" ] && continue
    if [ "$(skill_name "$other")" = "$name" ]; then echo "$other"; return 0; fi
  done
  return 1
}

# Older versions of this script left `<skill>.bak-<stamp>` folders inside the
# skills dir, where they load as duplicate skills. Move them out.
sweep_old_backups() { # sweep_old_backups <dst> <label>
  local dst="$1" label="$2" b
  [ -d "$dst" ] || return 0
  for b in "$dst"/*.bak-*; do
    [ -e "$b" ] || continue
    echo "  moving stale backup out of $label skills: $(basename "$b")"
    backup "$b" "old-backups/$label"
  done
}

install_skills() { # install_skills <src> <dst> <app: claude|codex>
  local src="$1" dst="$2" app="$3" d dir name dest where
  [ -d "$src" ] || return 0
  run mkdir -p "$dst"
  sweep_old_backups "$dst" "$app"
  for d in "$src"/*/; do
    d="${d%/}"; dir="$(basename "$d")"; name="$(skill_name "$d")"; dest="$dst/$dir"

    if where="$(plugin_providing "$app" "$name")"; then
      echo "  skip $app skill $name — already installed as a plugin (${where/#"$HOME"/\~})"
      SKIPPED=$((SKIPPED+1)); continue
    fi
    if where="$(same_name_elsewhere "$dst" "$dir" "$name")"; then
      echo "  skip $app skill $name — already installed at ${where/#"$HOME"/\~}"
      SKIPPED=$((SKIPPED+1)); continue
    fi
    if [ -e "$dest" ] && same_content "$d" "$dest"; then
      echo "  ok   $app skill $name — up to date"
      SKIPPED=$((SKIPPED+1)); continue
    fi
    if [ -L "$dest" ]; then
      echo "  skip $app skill $name — you linked it to $(readlink "$dest"); leaving it alone"
      SKIPPED=$((SKIPPED+1)); continue
    fi
    if [ -d "$dest/.git" ]; then
      echo "  skip $app skill $name — it's its own git checkout; update it with git pull"
      SKIPPED=$((SKIPPED+1)); continue
    fi

    if [ -e "$dest" ]; then
      echo "  update $app skill $name"
      backup "$dest" "$app-skills"
      UPDATED=$((UPDATED+1))
    else
      echo "  add  $app skill $name"
      INSTALLED=$((INSTALLED+1))
    fi
    run cp -R "$d" "$dest"
  done
}

install_file() { # install_file <src> <dst> <label> <backup-subdir>
  local src="$1" dst="$2" label="$3" sub="$4"
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    echo "  ok   $label — up to date"; SKIPPED=$((SKIPPED+1)); return 0
  fi
  if [ -e "$dst" ]; then
    echo "  update $label"; backup "$dst" "$sub" copy; UPDATED=$((UPDATED+1))
  else
    echo "  add  $label"; INSTALLED=$((INSTALLED+1))
  fi
  run cp "$src" "$dst"
}

echo "ClaudiusMaximus → installing to ~/.claude"
[ "$DRY_RUN" = 1 ] && echo "(dry run — nothing will change)"
run mkdir -p "$CMD_DST"

# Commands
for f in "$CMD_SRC"/*.md; do
  install_file "$f" "$CMD_DST/$(basename "$f")" "/$(basename "$f" .md)" commands
done

# Skills (one dir per skill, copied whole so scripts/ and references/ come along).
install_skills "$SCRIPT_DIR/skills"       "$HOME/.claude/skills" claude
install_skills "$SCRIPT_DIR/skills-codex" "$HOME/.codex/skills"  codex

# Global CLAUDE.md (user-level conventions applied to every project)
[ -f "$MD_SRC" ] && install_file "$MD_SRC" "$MD_DST" "CLAUDE.md (global conventions)" claude-md

# Shell aliases (claudelol / f -> launch straight into ultracode mode).
if [ -f "$ALIAS_SRC" ]; then
  install_file "$ALIAS_SRC" "$ALIAS_DST" "aliases (claudelol, f)" aliases

  RC=""
  if [ -f "$HOME/.zshrc" ]; then RC="$HOME/.zshrc"
  elif [ -f "$HOME/.bashrc" ]; then RC="$HOME/.bashrc"
  fi
  MARKER="# ClaudiusMaximus aliases"
  if [ -n "$RC" ]; then
    if grep -qF "$MARKER" "$RC"; then
      echo "  ok   aliases already wired into $RC"
    else
      backup "$RC" rc copy
      if [ "$DRY_RUN" = 1 ]; then echo "    (dry run) append source line to $RC"
      else printf '\n%s\nsource "%s"\n' "$MARKER" "$ALIAS_DST" >> "$RC"; fi
      echo "  wired aliases into $RC (run: source $RC)"
    fi
  else
    echo "  no ~/.zshrc or ~/.bashrc found — add this line to your shell rc:"
    echo "      source \"$ALIAS_DST\""
  fi
fi

echo
echo "Done: $INSTALLED added, $UPDATED updated, $SKIPPED already there."
[ "$UPDATED" -gt 0 ] && [ "$DRY_RUN" = 0 ] && echo "Old copies saved in ${BACKUP_ROOT/#"$HOME"/\~}"
echo "Restart Claude Code / Codex or start a new session to pick up changes."
echo "NOTE: invoice, coderabbit, and the intercept skill contain machine/user-specific"
echo "values — see README.md → Customize."

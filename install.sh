#!/usr/bin/env bash
# dotfiles installer — macOS / Linux (and Git Bash on Windows).
# Detects the platform, copies configs into place (backing up anything it
# replaces), wires the shell aliases in, and on macOS applies the WezTerm icon.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin)               OS=mac ;;
  Linux)                OS=linux ;;
  MINGW*|MSYS*|CYGWIN*) OS=windows ;;
  *)                    OS=unknown ;;
esac
echo "==> Installing dotfiles ($OS) from $DOTFILES"

backup() {  # backup a path if it exists
  if [ -e "$1" ]; then
    cp "$1" "$1.bak.$(date +%s)"
    echo "    backed up $1"
  fi
}

# 1. WezTerm config — same path on every platform: ~/.config/wezterm/wezterm.lua
WEZ_DIR="$HOME/.config/wezterm"
mkdir -p "$WEZ_DIR"
backup "$WEZ_DIR/wezterm.lua"
cp "$DOTFILES/wezterm/wezterm.lua" "$WEZ_DIR/wezterm.lua"
echo "  ✓ wezterm.lua -> $WEZ_DIR/wezterm.lua"

# 2. Starship prompt config — ~/.config/starship.toml on every platform.
mkdir -p "$HOME/.config"
backup "$HOME/.config/starship.toml"
cp "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
echo "  ✓ starship.toml -> $HOME/.config/starship.toml"

# 3. Shell aliases (cc, dn) + starship init — sourced from the repo, edits live.
ALIASES="$DOTFILES/shell/aliases.sh"
MARKER="# >>> dotfiles aliases >>>"
wired=0
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
  [ -e "$rc" ] || continue
  if grep -qF "$MARKER" "$rc"; then
    echo "  • aliases already wired in $rc"
  else
    printf '\n%s\n[ -f "%s" ] && source "%s"\n# <<< dotfiles aliases <<<\n' \
      "$MARKER" "$ALIASES" "$ALIASES" >> "$rc"
    echo "  ✓ wired aliases into $rc"
  fi
  wired=1
done
[ "$wired" = 1 ] || echo "  • no ~/.zshrc or ~/.bashrc found — add: source \"$ALIASES\""

# 4. WezTerm app icon (macOS only).
if [ "$OS" = mac ]; then
  bash "$DOTFILES/scripts/set-wezterm-icon.sh" || echo "  • icon step skipped"
else
  echo "  • icon auto-apply is macOS-only (see README for Windows)"
fi

echo "==> Done. Restart your shell, or: source ~/.zshrc"

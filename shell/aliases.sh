# dotfiles shell aliases — sourced from ~/.zshrc / ~/.bashrc by install.sh
# bash / zsh (macOS, Linux, Git Bash on Windows)

# cc: launch Claude Code skipping permission prompts.
# Shadows /usr/bin/cc (clang) in interactive shells only — Makefiles/scripts
# call the real cc binary directly, so builds are unaffected. Reach the
# compiler explicitly with `command cc`, `/usr/bin/cc`, or `clang`.
alias cc='claude --dangerously-skip-permissions'

# dn: open today's Obsidian daily note (created from the template if missing)
# and focus it. Uses the vault *name*, so it's portable across machines.
dn() {
  local uri="obsidian://daily?vault=Obsidian%20Vault"
  case "$(uname -s)" in
    Darwin)               open "$uri" ;;
    MINGW*|MSYS*|CYGWIN*) start "" "$uri" ;;
    *)                    xdg-open "$uri" >/dev/null 2>&1 ;;
  esac
}

# starship prompt (config installed at ~/.config/starship.toml)
if command -v starship >/dev/null 2>&1; then
  if [ -n "${ZSH_VERSION:-}" ];  then eval "$(starship init zsh)"
  elif [ -n "${BASH_VERSION:-}" ]; then eval "$(starship init bash)"
  fi
fi

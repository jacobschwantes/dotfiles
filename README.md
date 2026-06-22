# dotfiles

My configs. Clone and run the installer for the platform.

## macOS / Linux

```sh
git clone https://github.com/jacobschwantes/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
source ~/.zshrc
```

## Windows (PowerShell)

```powershell
git clone https://github.com/jacobschwantes/dotfiles.git $HOME\dotfiles
$HOME\dotfiles\install.ps1
. $PROFILE
```

The installer backs up anything it replaces, copies the WezTerm + starship
configs into `~/.config`, wires `cc`/`dn` + the starship prompt into my shell,
and on macOS applies the WezTerm app icon.

## Contents

- `wezterm/wezterm.lua` → `~/.config/wezterm/wezterm.lua`
- `starship/starship.toml` → `~/.config/starship.toml`
- `shell/aliases.sh` · `aliases.ps1` — `cc` (claude, skip perms), `dn` (today's
  Obsidian daily note), starship init. Sourced from the repo, so edits are live.
- `icon/wezterm.png` + `scripts/set-wezterm-icon.sh` — app icon (macOS).
  Re-run the script after a WezTerm update; Windows icon is manual.

Tool managers (nvm/pnpm/go/etc.) stay per-machine — not here.

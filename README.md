# dotfiles

Cross-platform (macOS / Windows / Linux) personal config. One install script per
platform auto-detects the OS, backs up anything it replaces, copies configs into
place, and wires up shell aliases.

## What's managed

| Item | Source | Installs to |
|------|--------|-------------|
| WezTerm config | `wezterm/wezterm.lua` | `~/.config/wezterm/wezterm.lua` (all platforms) |
| `cc` alias | `shell/aliases.sh` · `shell/aliases.ps1` | sourced from `~/.zshrc`/`~/.bashrc` · PowerShell `$PROFILE` |
| `dn` function | same | same |
| WezTerm app icon | `icon/wezterm.png` | `WezTerm.app` bundle (macOS only) |

- **`cc`** → `claude --dangerously-skip-permissions` (launch Claude Code, no permission prompts).
- **`dn`** → opens today's Obsidian daily note (created from your template if missing) and focuses it. Portable — it uses the vault *name* via the `obsidian://daily` URI.

The aliases are **sourced from this repo**, not copied — edit a file here and the
change is live in new shells. WezTerm config is copied (re-run install to update).

## Install

**macOS / Linux** (and Git Bash on Windows):

```sh
git clone https://github.com/jacobschwantes/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

**Windows** (PowerShell):

```powershell
git clone https://github.com/jacobschwantes/dotfiles.git $HOME\dotfiles
$HOME\dotfiles\install.ps1
# if blocked: powershell -ExecutionPolicy Bypass -File $HOME\dotfiles\install.ps1
```

Then restart your shell (or `source ~/.zshrc` / `. $PROFILE`).

## WezTerm app icon

The icon (`icon/wezterm.png`) is applied automatically by `install.sh` on macOS.
Re-run it standalone after a WezTerm update (updates overwrite the bundle icon):

```sh
~/dotfiles/scripts/set-wezterm-icon.sh
```

It clears the app's quarantine flag (so it stops launching from a translocated
temp path), rebuilds a full `.icns`, backs up the original, swaps it in, and
refreshes the icon caches. Revert with the `.bak` it leaves next to the icon.

**Windows:** the icon is embedded in `wezterm-gui.exe`, so it isn't swapped by a
script. To customize manually: right-click your WezTerm shortcut → Properties →
Change Icon, and point it at a `.ico` built from `icon/wezterm.png`.

## Notes

- `cc` shadows the system C compiler (`/usr/bin/cc`) in **interactive shells
  only** — Makefiles/scripts use the real binary. Reach it with `command cc`,
  `/usr/bin/cc`, or `clang`.
- Replacing the icon assumes WezTerm is in `/Applications`; pass a path as the
  2nd arg to `set-wezterm-icon.sh` otherwise.

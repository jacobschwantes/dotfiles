# dotfiles installer — Windows (PowerShell).
# Copies configs into place (backing up anything it replaces) and wires the
# shell aliases into your PowerShell profile.
#
#   Run from PowerShell:  .\install.ps1
#   (If blocked: powershell -ExecutionPolicy Bypass -File .\install.ps1)
$ErrorActionPreference = "Stop"
$Dotfiles = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "==> Installing dotfiles (windows) from $Dotfiles"

# 1. WezTerm config — WezTerm on Windows reads ~/.config/wezterm/wezterm.lua
$wezDir  = Join-Path $HOME ".config\wezterm"
New-Item -ItemType Directory -Force -Path $wezDir | Out-Null
$wezDest = Join-Path $wezDir "wezterm.lua"
if (Test-Path $wezDest) {
  Copy-Item $wezDest "$wezDest.bak" -Force
  Write-Host "    backed up $wezDest"
}
Copy-Item (Join-Path $Dotfiles "wezterm\wezterm.lua") $wezDest -Force
Write-Host "  OK wezterm.lua -> $wezDest"

# 2. Shell aliases (cc, dn) — dot-sourced from the repo via the PowerShell profile.
$aliases = Join-Path $Dotfiles "shell\aliases.ps1"
$marker  = "# >>> dotfiles aliases >>>"
if (-not (Test-Path $PROFILE)) { New-Item -ItemType File -Force -Path $PROFILE | Out-Null }
if (Select-String -Path $PROFILE -SimpleMatch $marker -Quiet) {
  Write-Host "  - aliases already wired in $PROFILE"
} else {
  Add-Content $PROFILE "`n$marker`n. `"$aliases`"`n# <<< dotfiles aliases <<<"
  Write-Host "  OK wired aliases into $PROFILE"
}

# 3. Icon — the Windows WezTerm icon is embedded in wezterm-gui.exe and can't be
#    swapped by a simple script. See README for the manual steps.
Write-Host "  - Icon auto-apply is macOS-only; see README for the manual Windows steps."

Write-Host "==> Done. Restart PowerShell, or:  . `$PROFILE"

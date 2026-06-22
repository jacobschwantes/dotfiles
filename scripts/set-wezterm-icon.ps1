# Apply the custom WezTerm icon on Windows.
#
# The icon is baked into wezterm-gui.exe and can't be swapped without tools like
# Resource Hacker. Instead this creates Desktop + Start Menu shortcuts that point
# at the real exe but use icon/wezterm.ico — that's the icon Windows shows in the
# Start Menu, on the desktop, and on the taskbar (when you pin from the shortcut).
#
#   Usage: .\set-wezterm-icon.ps1 [-Exe <path to wezterm-gui.exe>]
param([string]$Exe)
$ErrorActionPreference = "Stop"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ico  = Resolve-Path (Join-Path $here "..\icon\wezterm.ico")

# Locate wezterm-gui.exe if not passed in.
if (-not $Exe) {
  $cmd = Get-Command wezterm-gui.exe -ErrorAction SilentlyContinue
  if ($cmd) { $Exe = $cmd.Source }
  else {
    foreach ($p in @(
      "$env:ProgramFiles\WezTerm\wezterm-gui.exe",
      "$env:LOCALAPPDATA\Programs\WezTerm\wezterm-gui.exe",
      "${env:ProgramFiles(x86)}\WezTerm\wezterm-gui.exe"
    )) { if (Test-Path $p) { $Exe = $p; break } }
  }
}
if (-not $Exe -or -not (Test-Path $Exe)) {
  throw "wezterm-gui.exe not found. Pass it: .\set-wezterm-icon.ps1 -Exe 'C:\path\to\wezterm-gui.exe'"
}
Write-Host "exe : $Exe"
Write-Host "icon: $ico"

$ws = New-Object -ComObject WScript.Shell
$targets = @(
  (Join-Path ([Environment]::GetFolderPath('Desktop')) 'WezTerm.lnk'),
  (Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Programs\WezTerm.lnk')
)
foreach ($lnkPath in $targets) {
  New-Item -ItemType Directory -Force -Path (Split-Path $lnkPath) | Out-Null
  $lnk = $ws.CreateShortcut($lnkPath)
  $lnk.TargetPath   = $Exe
  $lnk.IconLocation = "$ico,0"
  $lnk.Save()
  Write-Host "  OK $lnkPath"
}

# Nudge Explorer to refresh its icon cache.
ie4uinit.exe -show 2>$null
Write-Host ""
Write-Host "Done. To fix the TASKBAR icon: unpin the current WezTerm, then pin the"
Write-Host "new Desktop/Start-Menu 'WezTerm' shortcut. If icons look stale, sign out"
Write-Host "and back in (or restart explorer.exe)."

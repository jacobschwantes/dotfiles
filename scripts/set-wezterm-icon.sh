#!/usr/bin/env bash
# Apply a PNG as the WezTerm.app icon on macOS.
# Also handy to re-run after a WezTerm update (updates overwrite the bundle icon).
#
#   Usage: set-wezterm-icon.sh [icon.png] [/path/to/WezTerm.app]
#   Defaults: ../icon/wezterm.png  and  /Applications/WezTerm.app
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${1:-$HERE/../icon/wezterm.png}"
APP="${2:-/Applications/WezTerm.app}"

[ "$(uname -s)" = "Darwin" ] || { echo "macOS only — skipping icon."; exit 0; }
[ -f "$SRC" ] || { echo "icon png not found: $SRC" >&2; exit 1; }
[ -d "$APP" ] || { echo "WezTerm.app not found: $APP — skipping icon." >&2; exit 0; }

# Clear quarantine so the app stops translocating (a quarantined app runs from a
# throwaway read-only copy, which would discard the icon swap).
xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true

# Resolve the bundle's actual icon filename (usually terminal.icns).
ICON_NAME="$(plutil -extract CFBundleIconFile raw "$APP/Contents/Info.plist" 2>/dev/null || echo terminal)"
ICON_NAME="${ICON_NAME%.icns}"
ICNS="$APP/Contents/Resources/$ICON_NAME.icns"

# Build a full iconset (16..1024) from the PNG and compile to .icns.
WORK="$(mktemp -d)"
ISET="$WORK/wz.iconset"; mkdir -p "$ISET"
for sz in 16 32 128 256 512; do
  sips -z "$sz" "$sz"             "$SRC" --out "$ISET/icon_${sz}x${sz}.png"    >/dev/null
  sips -z "$((sz*2))" "$((sz*2))" "$SRC" --out "$ISET/icon_${sz}x${sz}@2x.png" >/dev/null
done
iconutil -c icns "$ISET" -o "$WORK/$ICON_NAME.icns"

# Back up the original once, then replace.
[ -f "$ICNS.bak" ] || cp "$ICNS" "$ICNS.bak"
cp "$WORK/$ICON_NAME.icns" "$ICNS"
rm -rf "$WORK"

# Invalidate icon caches.
touch "$APP"
killall Dock   2>/dev/null || true
killall Finder 2>/dev/null || true

echo "✓ WezTerm icon applied from $SRC"
echo "  (restart WezTerm if its Dock icon still looks old)"

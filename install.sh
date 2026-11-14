#!/usr/bin/env bash
# Build Knightcap and install it into /Applications, then launch it.
set -euo pipefail
cd "$(dirname "$0")"
./scripts/build-app.sh
pkill -x Knightcap 2>/dev/null || true
rm -rf /Applications/Knightcap.app
cp -R Knightcap.app /Applications/
open /Applications/Knightcap.app
echo "Installed /Applications/Knightcap.app"
echo "Turn on Start at Login from the menu-bar icon (right-click)."
echo "Uninstall: pkill -x Knightcap; rm -rf /Applications/Knightcap.app"

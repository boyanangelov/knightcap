#!/usr/bin/env bash
# Build ChessBar.app with swiftc directly (no Xcode or SwiftPM needed).
set -euo pipefail
cd "$(dirname "$0")/.."

APP=ChessBar.app
rm -rf "$APP" .build/chessbar
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" .build/chessbar

swiftc -O -swift-version 5 \
  -target "$(uname -m)-apple-macos13.0" \
  -framework AppKit -framework SwiftUI -framework WebKit -framework Carbon -framework ServiceManagement \
  -module-cache-path .build/chessbar/cache \
  Sources/ChessBar/*.swift \
  -o "$APP/Contents/MacOS/ChessBar"

cp Resources/Info.plist "$APP/Contents/Info.plist"
codesign --force --sign - "$APP" >/dev/null
echo "Built $(pwd)/$APP"

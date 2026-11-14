#!/usr/bin/env bash
# Build Knightcap.app (Apple Silicon, macOS 13+) with swiftc.
# Needs only the Xcode Command Line Tools; no Xcode or SwiftPM.
set -euo pipefail
cd "$(dirname "$0")/.."

APP=Knightcap.app
TMP=.build/knightcap
rm -rf "$APP" "$TMP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" "$TMP"

swiftc -O -swift-version 5 \
  -target arm64-apple-macos13.0 \
  -framework AppKit -framework SwiftUI -framework WebKit -framework Carbon -framework ServiceManagement \
  -module-cache-path "$TMP/cache" \
  Sources/Knightcap/*.swift \
  -o "$APP/Contents/MacOS/Knightcap"

cp Resources/Info.plist "$APP/Contents/Info.plist"
codesign --force --sign - "$APP" >/dev/null 2>&1
echo "Built $(pwd)/$APP"

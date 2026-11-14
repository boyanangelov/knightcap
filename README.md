# Knightcap

A tiny macOS menu-bar app that opens [Lichess](https://lichess.org) puzzles in a small floating window: one click (or **⌥⌘P**) and you're solving.

## Why

I wanted a quick puzzle or two between tasks without opening a browser, finding the tab and losing ten minutes on the home page. Knightcap keeps Lichess one click away in the menu bar, in a square window that floats above your work and hides again when you're done. A puzzle in progress keeps its place while the window is hidden.

Lichess is free, open source and ad-free, which makes it a good fit for an always-there companion like this.

## Features

- **Puzzles, Puzzle Storm, Daily Puzzle and Play** tabs, right in the window's title bar
- Square, resizable window that floats above other apps and follows you across Spaces and full-screen apps
- Global hotkey **⌥⌘P** to show or hide it from anywhere
- Stays signed in to your Lichess account between launches (puzzles also work without an account)
- Start at Login
- No Dock icon, no dependencies

## Download

Grab `Knightcap.zip` from the [latest release](https://github.com/boyanangelov/knightcap/releases/latest), unzip it and move `Knightcap.app` to Applications.

The app isn't signed with an Apple Developer ID, so macOS blocks it the first time. To open it anyway: right-click the app and choose **Open**, or go to **System Settings ▸ Privacy & Security** and click **Open Anyway**. You can also clear the quarantine flag from a terminal:

```sh
xattr -dr com.apple.quarantine /Applications/Knightcap.app
```

## Requirements

- An Apple Silicon Mac (M1 or later) running macOS 13 (Ventura) or later
- To build from source: the Xcode Command Line Tools (`xcode-select --install`)

## Build & run

```sh
./scripts/build-app.sh
open Knightcap.app
```

- **Left-click** the menu-bar icon, or press **⌥⌘P**, to show or hide the window.
- **Right-click** the icon for the menu: Puzzles, Puzzle Storm, Daily Puzzle, Play, Reload, Start at Login and Quit.

## Start at login

Install the app into `/Applications` first, so macOS has a stable place to launch it from:

```sh
./install.sh
```

Then right-click the menu-bar icon and tick **Start at Login**. Knightcap registers itself as a login item, and it appears under **System Settings ▸ General ▸ Login Items**. Untick it to remove it.

## How it works

Knightcap is a native AppKit/SwiftUI shell around a `WKWebView` showing lichess.org, in an always-on-top panel. Your Lichess session is kept in the app's own website data store, separate from your browser. Knightcap isn't affiliated with Lichess.

## License

[MIT](LICENSE)

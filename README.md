# ChessBar

A macOS menubar app for Lichess puzzles, Puzzle Storm, the daily puzzle and quick games. It shows lichess.org in a small floating window that stays on top.

## Build & run
```bash
./scripts/build-app.sh
open ChessBar.app            # or: cp -R ChessBar.app /Applications/
```
Needs macOS 13+ and the Swift toolchain. Command Line Tools are enough; Xcode isn't required.

## Use
- **Left-click** the menubar icon, or press **⌥⌘P** from anywhere, to show or hide the window.
- **Right-click** the icon for the menu: Puzzles, Puzzle Storm, Daily Puzzle, Play, Reload, Start at Login and Quit.
- Log in once inside the window if you want rated puzzles and games. The session persists across launches. Puzzles also work without an account.

To use **Start at Login**, copy `ChessBar.app` to `/Applications` first, so macOS has a stable location to launch it from.

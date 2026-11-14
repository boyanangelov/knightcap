import AppKit
import SwiftUI
import Carbon.HIToolbox
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var panel: FloatingPanel!
    private var hotKey: HotKey?
    private let state = AppState()

    func applicationDidFinishLaunching(_ notification: Notification) {
        panel = FloatingPanel(contentView: NSHostingView(rootView: ContentView(state: state)))

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = AppDelegate.boardIcon()
            button.target = self
            button.action = #selector(statusClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        hotKey = HotKey(keyCode: UInt32(kVK_ANSI_P), modifiers: UInt32(optionKey | cmdKey)) { [weak self] in
            DispatchQueue.main.async { self?.panel.toggle() }
        }

        panel.show()
    }

    @objc private func statusClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent
        if event?.type == .rightMouseUp || event?.modifierFlags.contains(.control) == true {
            showMenu()
        } else {
            panel.toggle()
        }
    }

    private func showMenu() {
        let menu = NSMenu()
        for (i, route) in Route.allCases.enumerated() {
            let item = NSMenuItem(title: route.menuTitle, action: #selector(openRoute(_:)), keyEquivalent: "\(i + 1)")
            item.target = self
            item.representedObject = route.rawValue
            item.state = state.route == route ? .on : .off
            menu.addItem(item)
        }
        menu.addItem(.separator())
        let reload = NSMenuItem(title: "Reload", action: #selector(reload), keyEquivalent: "r")
        reload.target = self
        menu.addItem(reload)
        menu.addItem(.separator())
        let login = NSMenuItem(title: "Start at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        login.target = self
        login.state = SMAppService.mainApp.status == .enabled ? .on : .off
        menu.addItem(login)
        menu.addItem(NSMenuItem(title: "Quit Knightcap", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil // restore left-click toggling
    }

    /// Square 4×4 chessboard glyph for the menu bar (template image, adapts to light/dark).
    static func boardIcon() -> NSImage {
        let size: CGFloat = 16
        let img = NSImage(size: NSSize(width: size, height: size), flipped: false) { rect in
            let inset = rect.insetBy(dx: 1, dy: 1)
            let frame = NSBezierPath(roundedRect: inset, xRadius: 2.5, yRadius: 2.5)
            NSColor.black.setStroke()
            frame.lineWidth = 1.4
            frame.stroke()
            frame.addClip()
            let cell = inset.width / 4
            NSColor.black.setFill()
            for row in 0..<4 {
                for col in 0..<4 where (row + col) % 2 == 0 {
                    NSRect(x: inset.minX + CGFloat(col) * cell, y: inset.minY + CGFloat(row) * cell,
                           width: cell, height: cell).fill()
                }
            }
            return true
        }
        img.isTemplate = true
        img.accessibilityDescription = "Knightcap"
        return img
    }

    @objc private func openRoute(_ sender: NSMenuItem) {
        if let raw = sender.representedObject as? String, let route = Route(rawValue: raw) {
            state.route = route
        }
        panel.show()
    }

    @objc private func toggleLaunchAtLogin() {
        let service = SMAppService.mainApp
        do {
            if service.status == .enabled {
                try service.unregister()
            } else {
                try service.register()
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = "Couldn't change Start at Login"
            alert.informativeText = error.localizedDescription
                + "\n\nTip: move Knightcap.app to /Applications first."
            alert.runModal()
        }
    }

    @objc private func reload() { state.reloadToken += 1; panel.show() }
}

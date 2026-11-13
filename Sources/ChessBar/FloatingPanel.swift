import AppKit

/// Always-on-top, resizable window that hides instead of closing.
final class FloatingPanel: NSPanel {
    init(contentView: NSView) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 520),
            styleMask: [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        title = "ChessBar"
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        level = .floating
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isReleasedWhenClosed = false
        hidesOnDeactivate = false
        isMovableByWindowBackground = true
        appearance = NSAppearance(named: .darkAqua)
        backgroundColor = NSColor(red: 0.086, green: 0.082, blue: 0.071, alpha: 1)
        aspectRatio = NSSize(width: 1, height: 1) // keep the window square while resizing
        minSize = NSSize(width: 360, height: 360)
        self.contentView = contentView
        if !setFrameUsingName("ChessBarPanelSquare") { center() }
        setFrameAutosaveName("ChessBarPanelSquare")
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func performClose(_ sender: Any?) { hide() }

    func show() {
        NSApp.activate(ignoringOtherApps: true)
        makeKeyAndOrderFront(nil)
    }

    func hide() { orderOut(nil) }

    func toggle() {
        if isVisible && isKeyWindow { hide() } else { show() }
    }
}

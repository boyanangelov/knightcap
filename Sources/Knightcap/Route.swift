import Foundation

enum Route: String, CaseIterable, Identifiable {
    case puzzles, storm, daily, play

    var id: String { rawValue }

    var title: String {
        switch self {
        case .puzzles: return "Puzzles"
        case .storm: return "Storm"
        case .daily: return "Daily"
        case .play: return "Play"
        }
    }

    var menuTitle: String {
        switch self {
        case .puzzles: return "Puzzles"
        case .storm: return "Puzzle Storm"
        case .daily: return "Daily Puzzle"
        case .play: return "Play"
        }
    }

    var url: URL {
        let path: String
        switch self {
        case .puzzles: path = "/training"
        case .storm: path = "/storm"
        case .daily: path = "/training/daily"
        case .play: path = "/"
        }
        return URL(string: "https://lichess.org" + path)!
    }
}

/// Shared UI state between the status-item menu and the SwiftUI content.
final class AppState: ObservableObject {
    @Published var route: Route = .puzzles
    /// Incremented to request a reload of the current page.
    @Published var reloadToken = 0
}

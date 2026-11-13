import SwiftUI

struct ContentView: View {
    @ObservedObject var state: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar lives inside the (transparent) title bar, beside the traffic lights.
            HStack(spacing: 6) {
                Spacer().frame(width: 64) // traffic lights
                Picker("", selection: $state.route) {
                    ForEach(Route.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .controlSize(.small)
                .fixedSize()

                Spacer(minLength: 0)

                Button { state.reloadToken += 1 } label: {
                    Image(systemName: "arrow.clockwise").font(.system(size: 11, weight: .semibold))
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
                .help("Reload")
            }
            .padding(.trailing, 10)
            .frame(height: 28)

            WebView(route: state.route, reloadToken: state.reloadToken)
        }
        .background(Color(red: 0.086, green: 0.082, blue: 0.071)) // lichess dark bg (#161512)
        .ignoresSafeArea()
    }
}

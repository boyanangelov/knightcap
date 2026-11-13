import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let route: Route
    let reloadToken: Int

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var loadedRoute: Route?
        var reloadToken = 0

        // Open target=_blank links in the same view instead of dropping them.
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                     for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
            return nil
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default() // persistent cookies → stays logged in
        config.mediaTypesRequiringUserActionForPlayback = [] // move sounds
        let view = WKWebView(frame: .zero, configuration: config)
        view.navigationDelegate = context.coordinator
        view.uiDelegate = context.coordinator
        view.allowsBackForwardNavigationGestures = true
        return view
    }

    func updateNSView(_ view: WKWebView, context: Context) {
        let c = context.coordinator
        if c.loadedRoute != route {
            c.loadedRoute = route
            view.load(URLRequest(url: route.url))
        } else if c.reloadToken != reloadToken {
            view.reload()
        }
        c.reloadToken = reloadToken
    }
}

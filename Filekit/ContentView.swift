import AppKit
import SwiftUI

/// Minimal host window so the Finder Sync extension can be registered and enabled.
struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filekit")
                .font(.title2)
            Text("Phase 0 — enable the Finder extension, then use Copy Path from Finder’s right-click menu.")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 6) {
                Text("1. Running this app once registers the extension with macOS.")
                Text("2. Enable Filekit in System Settings → Login Items & Extensions (see the README).")
                Text("3. In Finder, select a file, right-click, and choose Copy Path.")
                Text("4. Paste to confirm the absolute path is on the clipboard.")
            }
            Button("Open System Settings") {
                openExtensionsSettings()
            }
        }
        .padding(20)
        .frame(minWidth: 420, idealWidth: 480, maxWidth: 560, alignment: .leading)
    }

    private func openExtensionsSettings() {
        let candidates = [
            "x-apple.systempreferences:com.apple.LoginItems-Settings.extension",
            "x-apple.systempreferences:com.apple.ExtensionsPreferences",
        ]
        for candidate in candidates {
            if let url = URL(string: candidate), NSWorkspace.shared.open(url) {
                return
            }
        }
    }
}

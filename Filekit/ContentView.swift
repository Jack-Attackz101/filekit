import AppKit
import SwiftUI

/// Host window: registers the Finder Sync extension and previews Filekit › chrome.
/// Finder itself cannot draw this cream panel — see README.
struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FilekitBrand.spacing) {
            FilekitStampPanel()

            VStack(alignment: .leading, spacing: 8) {
                Text("Phase 1.1 polish — draft until Phase 0 passes")
                    .font(.system(size: 13, weight: .heavy, design: .serif))
                    .foregroundStyle(FilekitTheme.ink)

                Text("Finder shows a native Filekit › submenu with Copy Path. This cream panel is the host preview. Finder Sync cannot paint custom chrome.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(FilekitTheme.ink.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 6) {
                    Text("1. Running this app once registers the extension with macOS.")
                    Text("2. Enable Filekit in System Settings → Login Items & Extensions (see the README).")
                    Text("3. In Finder, select a file, right-click, open Filekit ›, and choose Copy Path.")
                    Text("4. Paste to confirm the absolute path is on the clipboard.")
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(FilekitTheme.ink)
            }

            Button(action: openExtensionsSettings) {
                Text("Open System Settings")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundStyle(FilekitTheme.ink)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        FilekitTheme.mango,
                        in: RoundedRectangle(cornerRadius: FilekitBrand.cornerRadius, style: .circular)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: FilekitBrand.cornerRadius, style: .circular)
                            .strokeBorder(FilekitTheme.ink, lineWidth: FilekitBrand.outlineWidth)
                    )
            }
            .buttonStyle(HostStampButtonStyle())
            .shadow(
                color: FilekitTheme.ink,
                radius: 0,
                x: FilekitBrand.printShadowOffset,
                y: FilekitBrand.printShadowOffset
            )
            .padding(.trailing, FilekitBrand.printShadowOffset)
            .padding(.bottom, FilekitBrand.printShadowOffset)
        }
        .padding(FilekitBrand.spacing)
        .frame(minWidth: 440, idealWidth: 500, maxWidth: 560, alignment: .leading)
        .background(FilekitTheme.cream)
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

private struct HostStampButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .offset(
                x: configuration.isPressed ? 1 : 0,
                y: configuration.isPressed ? 1 : 0
            )
    }
}

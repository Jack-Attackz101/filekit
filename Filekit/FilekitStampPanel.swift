import AppKit
import SwiftUI

/// SwiftUI wrappers for the shared AppKit studio tokens.
enum FilekitTheme {
    static let cream = Color(nsColor: FilekitBrand.creamNS)
    static let ink = Color(nsColor: FilekitBrand.inkNS)
    static let fruit = Color(nsColor: FilekitBrand.fruitNS)
    static let leaf = Color(nsColor: FilekitBrand.leafNS)
    static let mango = Color(nsColor: FilekitBrand.mangoActionNS)
}

/// In-panel fruit mark: fruit `#FFE169` + leaf `#4BA33D`, no stroke.
struct FruitMark: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            context.fill(Path(MangoGeometry.bodyPath(in: rect)), with: .color(FilekitTheme.fruit))
            context.fill(Path(MangoGeometry.leafPath(in: rect)), with: .color(FilekitTheme.leaf))
        }
        .accessibilityHidden(true)
    }
}

/// Host-only preview of the Filekit › submenu. Finder cannot render this chrome.
struct FilekitStampPanel: View {
    @State private var isCopyPathHovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: FilekitBrand.spacing) {
            Text(FilekitBrand.parentMenuTitle)
                .font(.system(size: 26, weight: .heavy, design: .serif))
                .tracking(-0.9)
                .foregroundStyle(FilekitTheme.ink)

            CopyPathPreviewRow(isHovering: $isCopyPathHovering)

            FilekitMangoFooter()
        }
        .padding(FilekitBrand.spacing)
        .background(
            FilekitTheme.cream,
            in: RoundedRectangle(cornerRadius: FilekitBrand.cornerRadius, style: .circular)
        )
        .overlay(
            RoundedRectangle(cornerRadius: FilekitBrand.cornerRadius, style: .circular)
                .strokeBorder(FilekitTheme.ink, lineWidth: FilekitBrand.outlineWidth)
        )
        .compositingGroup()
        .shadow(
            color: FilekitTheme.ink,
            radius: 0,
            x: FilekitBrand.printShadowOffset,
            y: FilekitBrand.printShadowOffset
        )
        .padding(.trailing, FilekitBrand.printShadowOffset)
        .padding(.bottom, FilekitBrand.printShadowOffset)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Filekit menu preview")
    }
}

/// First branded row: Copy Path. Same pasteboard behavior as Finder (absolute paths).
private struct CopyPathPreviewRow: View {
    @Binding var isHovering: Bool

    var body: some View {
        Button(action: copyHostPath) {
            HStack(spacing: 10) {
                Image(nsImage: FilekitMenuIcon.copyPath(pointSize: 18))
                    .renderingMode(.original)
                    .interpolation(.high)
                    .accessibilityHidden(true)
                Text(FilekitBrand.copyPathTitle)
                    .font(.system(size: 15, weight: .semibold))
                Spacer(minLength: 0)
            }
            .foregroundStyle(FilekitTheme.ink)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                isHovering ? FilekitTheme.mango : FilekitTheme.cream,
                in: RoundedRectangle(cornerRadius: FilekitBrand.cornerRadius, style: .circular)
            )
            .overlay(
                RoundedRectangle(cornerRadius: FilekitBrand.cornerRadius, style: .circular)
                    .strokeBorder(FilekitTheme.ink.opacity(isHovering ? 1 : 0.18), lineWidth: 1.5)
            )
        }
        .buttonStyle(StampPressStyle())
        .onHover { isHovering = $0 }
        .accessibilityLabel(FilekitBrand.copyPathTitle)
        .accessibilityHint("Copies this app’s path. In Finder, Copy Path copies the selected items.")
    }

    private func copyHostPath() {
        let url = URL(fileURLWithPath: Bundle.main.bundlePath)
        let string = FilekitCopyPath.pasteboardString(from: [url])
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }
}

/// Canonical studio footer: fruit mark + lowercase mango studios + fine print.
struct FilekitMangoFooter: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Rectangle()
                .fill(FilekitTheme.ink)
                .frame(height: FilekitBrand.outlineWidth)

            HStack(alignment: .center, spacing: 10) {
                FruitMark()
                    .frame(width: 28, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(FilekitBrand.studioName)
                        .font(.system(size: 14, weight: .heavy))
                        .tracking(-0.45)
                    Text("© 2026 \(FilekitBrand.studioName)")
                        .font(.system(size: 11, weight: .medium))
                        .opacity(0.7)
                }
                .foregroundStyle(FilekitTheme.ink)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(FilekitBrand.studioName)
    }
}

/// Flat press — offset reads as a stamp being pressed.
private struct StampPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1)
            .offset(
                x: configuration.isPressed ? 1 : 0,
                y: configuration.isPressed ? 1 : 0
            )
    }
}

#Preview("Filekit stamp panel") {
    FilekitStampPanel()
        .padding(24)
        .background(FilekitTheme.cream)
}

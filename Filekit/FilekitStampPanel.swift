import AppKit
import SwiftUI

/// SwiftUI wrappers for the Tess-locked AppKit tokens.
enum FilekitTheme {
    static let cream = Color(nsColor: FilekitBrand.creamNS)
    static let ink = Color(nsColor: FilekitBrand.inkNS)
    static let fruit = Color(nsColor: FilekitBrand.fruitNS)
    static let leaf = Color(nsColor: FilekitBrand.leafNS)
    static let mango = Color(nsColor: FilekitBrand.mangoActionNS)
}

/// Footer mark: pale mango `#FFE169` + one detached leaf, no outline.
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
        VStack(alignment: .leading, spacing: 6) {
            Text(FilekitBrand.parentMenuTitle)
                .font(.system(size: 26, weight: .heavy, design: .serif))
                .tracking(-0.9)
                .foregroundStyle(FilekitTheme.ink)
                .padding(.bottom, 4)

            CopyPathPreviewRow(isHovering: $isCopyPathHovering)

            ForEach(0..<FilekitBrand.reservedBlankRowCount, id: \.self) { _ in
                BlankReservedRow()
            }

            FilekitMangoFooter()
                .padding(.top, 8)
        }
        .padding(FilekitBrand.spacing)
        .frame(maxWidth: .infinity, alignment: .leading)
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

/// First real row: Copy Path. Full-row mango hover, ink text.
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isHovering ? FilekitTheme.mango : Color.clear)
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

/// Reserved slots. Blank until Jack adds actions. Host-only — not in Finder.
private struct BlankReservedRow: View {
    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 38)
            .accessibilityHidden(true)
    }
}

/// Footer is only the pale mango + detached leaf. No outline, no wordmark.
struct FilekitMangoFooter: View {
    var body: some View {
        FruitMark()
            .frame(width: 36, height: 52)
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

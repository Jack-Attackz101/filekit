import AppKit

/// Tess Phase 1.1 pixel lock (Sol stamped). Product name is Filekit — never Handy.
enum FilekitBrand {
    static let parentMenuTitle = "Filekit ›"
    static let copyPathTitle = "Copy Path"
    static let studioName = "mango studios"
    static let productName = "Filekit"

    /// Extra host rows stay blank until Jack adds actions. Finder does not show these.
    static let reservedBlankRowCount = 3

    /// Cream panel `#FFF9ED`.
    static let creamNS = NSColor(srgbRed: 0xFF / 255, green: 0xF9 / 255, blue: 0xED / 255, alpha: 1)
    /// Ink outline / type / print-stamp shadow `#24211D`.
    static let inkNS = NSColor(srgbRed: 0x24 / 255, green: 0x21 / 255, blue: 0x1D / 255, alpha: 1)
    /// Footer fruit `#FFE169` (pale mango). No outline.
    static let fruitNS = NSColor(srgbRed: 0xFF / 255, green: 0xE1 / 255, blue: 0x69 / 255, alpha: 1)
    /// Footer detached leaf `#4BA33D`. No outline.
    static let leafNS = NSColor(srgbRed: 0x4B / 255, green: 0xA3 / 255, blue: 0x3D / 255, alpha: 1)
    /// Full-row hover `#FFC928`. Ink text on top.
    static let mangoActionNS = NSColor(srgbRed: 0xFF / 255, green: 0xC9 / 255, blue: 0x28 / 255, alpha: 1)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 16
    static let outlineWidth: CGFloat = 2
    /// Print stamp shadow: `4px 4px 0` ink — hard offset, no blur.
    static let printShadowOffset: CGFloat = 4
}

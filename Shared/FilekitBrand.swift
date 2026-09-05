import AppKit

/// Mango Studios tokens (Sol / studio site) and Phase 1.1 menu copy.
/// Product name is Filekit — never Handy.
enum FilekitBrand {
    static let parentMenuTitle = "Filekit ›"
    static let copyPathTitle = "Copy Path"
    static let studioName = "mango studios"
    static let productName = "Filekit"

    /// Cream panel / type on ink. Studio `--cream`.
    static let creamNS = NSColor(srgbRed: 0xFF / 255, green: 0xF9 / 255, blue: 0xED / 255, alpha: 1)
    /// Ink outline, type, print-stamp shadow. Studio `--ink`.
    static let inkNS = NSColor(srgbRed: 0x24 / 255, green: 0x21 / 255, blue: 0x1D / 255, alpha: 1)
    /// Filled fruit body. Studio `--mango-logo`.
    static let fruitNS = NSColor(srgbRed: 0xFF / 255, green: 0xE1 / 255, blue: 0x69 / 255, alpha: 1)
    /// Detached leaf. Studio `--leaf-logo`.
    static let leafNS = NSColor(srgbRed: 0x4B / 255, green: 0xA3 / 255, blue: 0x3D / 255, alpha: 1)
    /// Mango hover / action fill. Studio `--mango`.
    static let mangoActionNS = NSColor(srgbRed: 0xFF / 255, green: 0xC9 / 255, blue: 0x28 / 255, alpha: 1)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 16
    static let outlineWidth: CGFloat = 2
    /// Print shadow once: `4px 4px 0 ink` — hard offset, no blur.
    static let printShadowOffset: CGFloat = 4
}

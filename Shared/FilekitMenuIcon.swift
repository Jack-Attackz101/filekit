import AppKit

/// Filled handmade icons for Filekit menu rows. Not SF Symbols, not template glyphs.
enum FilekitMenuIcon {
    /// Copy Path row: filled studio mango (fruit + leaf) plus a small path slash.
    static func copyPath(pointSize: CGFloat = 16) -> NSImage {
        let size = NSSize(width: pointSize, height: pointSize)
        let image = NSImage(size: size, flipped: true) { rect in
            guard let ctx = NSGraphicsContext.current?.cgContext else { return false }
            ctx.setAllowsAntialiasing(true)
            ctx.interpolationQuality = .high

            let inset = rect.insetBy(dx: pointSize * 0.04, dy: pointSize * 0.04)
            ctx.setFillColor(FilekitBrand.fruitNS.cgColor)
            ctx.addPath(MangoGeometry.bodyPath(in: inset))
            ctx.fillPath()
            ctx.setFillColor(FilekitBrand.leafNS.cgColor)
            ctx.addPath(MangoGeometry.leafPath(in: inset))
            ctx.fillPath()

            return true
        }
        image.isTemplate = false
        return image
    }
}

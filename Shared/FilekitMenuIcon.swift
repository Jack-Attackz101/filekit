import AppKit

/// Filled rounded pictograms (2–5 shapes). Not SF Symbols, not the mango footer stamp.
enum FilekitMenuIcon {
    /// Copy Path: 4 filled rounded shapes — document, two path bars, one pip.
    static func copyPath(pointSize: CGFloat = 16) -> NSImage {
        let size = NSSize(width: pointSize, height: pointSize)
        let image = NSImage(size: size, flipped: true) { rect in
            guard let ctx = NSGraphicsContext.current?.cgContext else { return false }
            ctx.setAllowsAntialiasing(true)
            ctx.interpolationQuality = .high
            ctx.setFillColor(FilekitBrand.inkNS.cgColor)

            let inset = pointSize * 0.12
            let doc = rect.insetBy(dx: inset, dy: inset * 0.7)
            let corner = max(2.0, pointSize * 0.16)

            // 1. Rounded document
            ctx.addPath(CGPath(roundedRect: doc, cornerWidth: corner, cornerHeight: corner, transform: nil))
            ctx.fillPath()

            ctx.setFillColor(FilekitBrand.creamNS.cgColor)
            let barHeight = max(1.6, pointSize * 0.1)
            let barCorner = barHeight / 2
            let barX = doc.minX + pointSize * 0.14
            let barMax = doc.width * 0.58

            // 2. Path bar
            let bar1 = CGRect(
                x: barX,
                y: doc.minY + doc.height * 0.30,
                width: barMax,
                height: barHeight
            )
            ctx.addPath(CGPath(roundedRect: bar1, cornerWidth: barCorner, cornerHeight: barCorner, transform: nil))
            ctx.fillPath()

            // 3. Shorter path bar
            let bar2 = CGRect(
                x: barX,
                y: doc.minY + doc.height * 0.52,
                width: barMax * 0.68,
                height: barHeight
            )
            ctx.addPath(CGPath(roundedRect: bar2, cornerWidth: barCorner, cornerHeight: barCorner, transform: nil))
            ctx.fillPath()

            // 4. Rounded pip
            let pipSize = max(2.4, pointSize * 0.16)
            let pip = CGRect(
                x: doc.maxX - pointSize * 0.22,
                y: doc.maxY - pointSize * 0.28,
                width: pipSize,
                height: pipSize
            )
            ctx.addPath(CGPath(roundedRect: pip, cornerWidth: pipSize / 2, cornerHeight: pipSize / 2, transform: nil))
            ctx.fillPath()

            return true
        }
        image.isTemplate = false
        return image
    }
}

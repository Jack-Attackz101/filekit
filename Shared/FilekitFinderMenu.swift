import AppKit

/// Native Finder Sync menu: `Filekit ›` parent with one child, Copy Path.
///
/// Finder draws this as a system `NSMenu`. It will not paint a cream panel,
/// 2px ink outline, 16pt corners, print-stamp shadow, or mango hover.
/// Those live in the host preview (`FilekitStampPanel`).
enum FilekitFinderMenu {
    static func makeContextualMenu(target: AnyObject, copyPath: Selector) -> NSMenu {
        let menu = NSMenu(title: "")

        let parent = NSMenuItem(title: FilekitBrand.parentMenuTitle, action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: FilekitBrand.parentMenuTitle)

        let copyItem = NSMenuItem(
            title: FilekitBrand.copyPathTitle,
            action: copyPath,
            keyEquivalent: ""
        )
        copyItem.target = target
        copyItem.image = FilekitMenuIcon.copyPath()

        submenu.addItem(copyItem)
        parent.submenu = submenu
        menu.addItem(parent)
        return menu
    }
}

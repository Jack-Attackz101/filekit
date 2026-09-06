import Cocoa
import FinderSync

/// Finder Sync principal class. Adds a single contextual menu item: Copy Path.
final class FinderSync: FIFinderSync {
    override init() {
        super.init()
        NSLog("Filekit Finder Sync loaded from %@", Bundle.main.bundlePath)
        refreshMonitoredDirectories()
        observeVolumeChanges()
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")
        guard menuKind == .contextualMenuForItems else {
            return menu
        }

        menu.addItem(
            withTitle: "Copy Path",
            action: #selector(copyPath(_:)),
            keyEquivalent: ""
        )
        return menu
    }

    @objc private func copyPath(_ sender: AnyObject?) {
        let urls = currentSelectionURLs()
        guard !urls.isEmpty else { return }

        let pasteboardString = urls.map(\.path).joined(separator: "\n")
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(pasteboardString, forType: .string)
    }

    /// Absolute paths of the current Finder selection. Falls back to the clicked item.
    private func currentSelectionURLs() -> [URL] {
        let controller = FIFinderSyncController.default()
        if let selected = controller.selectedItemURLs(), !selected.isEmpty {
            return selected
        }
        if let targeted = controller.targetedURL() {
            return [targeted]
        }
        return []
    }

    /// Finder Sync only attaches menus inside monitored directories, and does not cross volume boundaries.
    private func refreshMonitoredDirectories() {
        var urls = Set(
            FileManager.default.mountedVolumeURLs(
                includingResourceValuesForKeys: nil,
                options: [.skipHiddenVolumes]
            ) ?? []
        )
        urls.insert(URL(fileURLWithPath: "/"))
        FIFinderSyncController.default().directoryURLs = urls
    }

    private func observeVolumeChanges() {
        let center = NSWorkspace.shared.notificationCenter
        let names: [NSNotification.Name] = [
            NSWorkspace.didMountNotification,
            NSWorkspace.didUnmountNotification,
            NSWorkspace.didRenameVolumeNotification,
        ]
        for name in names {
            center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
                self?.refreshMonitoredDirectories()
            }
        }
    }
}

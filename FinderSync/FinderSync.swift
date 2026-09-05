import Cocoa
import FinderSync

/// Finder Sync principal class. Phase 1.1: native Filekit › parent, Copy Path child.
///
/// What Finder can show: nested `NSMenu` titles and an `NSMenuItem.image`.
/// What Finder cannot show: cream panel, ink outline, 16pt corners, print-stamp
/// shadow, or mango hover. That chrome lives in the host `FilekitStampPanel`.
final class FinderSync: FIFinderSync {
    override init() {
        super.init()
        NSLog("Filekit Finder Sync loaded from %@", Bundle.main.bundlePath)
        refreshMonitoredDirectories()
        observeVolumeChanges()
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        guard menuKind == .contextualMenuForItems else {
            return NSMenu(title: "")
        }
        return FilekitFinderMenu.makeContextualMenu(
            target: self,
            copyPath: #selector(copyPath(_:))
        )
    }

    @objc private func copyPath(_ sender: AnyObject?) {
        let urls = currentSelectionURLs()
        guard !urls.isEmpty else { return }

        let pasteboardString = FilekitCopyPath.pasteboardString(from: urls)
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

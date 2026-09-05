import Foundation

/// Phase 0 Copy Path pasteboard string. Absolute POSIX paths, newline-joined.
enum FilekitCopyPath {
    static func pasteboardString(from urls: [URL]) -> String {
        pasteboardString(fromPaths: urls.map(\.path))
    }

    static func pasteboardString(fromPaths paths: [String]) -> String {
        paths.joined(separator: "\n")
    }
}

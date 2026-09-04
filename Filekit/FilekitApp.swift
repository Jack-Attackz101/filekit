import SwiftUI

@main
struct FilekitApp: App {
    var body: some Scene {
        Window("Filekit", id: "main") {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}

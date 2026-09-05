import SwiftUI

@main
struct FilekitApp: App {
    var body: some Scene {
        Window(FilekitBrand.productName, id: "main") {
            ContentView()
        }
        .windowResizability(.contentSize)
    }
}

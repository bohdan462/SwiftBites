import SwiftUI

@main
struct SwiftBitesApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
            .modelContainer(SwiftBitesContainer.create())
    }
  }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}

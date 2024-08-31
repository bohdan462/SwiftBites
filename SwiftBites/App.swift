import SwiftUI

@main
struct SwiftBitesApp: App {
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    
                    ContentView()
                    
                }
                .preferredColorScheme(.dark)
                .modelContainer(SwiftBitesContainer.create())
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
        }
    }
    
    init() {
        //        print(URL.applicationSupportDirectory.path(percentEncoded: false))
        
    }
}

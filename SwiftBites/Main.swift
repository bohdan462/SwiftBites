import SwiftUI
import SwiftData

/// The main view that appears when the app is launched.
struct ContentView: View {
    
    @Environment(\.modelContext) private var storage
    
    @State private var lastModified = Date.now
    
    private var didSavePublisher: NotificationCenter.Publisher {
        NotificationCenter.default
            .publisher(for: ModelContext.willSave, object: storage)
    }
    
    var body: some View {
        TabView {
//            Text(lastModified.formatted(date: .abbreviated, time: .shortened))
//                .onReceive(didSavePublisher) { _ in
//                    lastModified = Date.now
//                }
            
            RecipesView()
                .tabItem {
                    Label("Recipes", systemImage: "frying.pan")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }
            
            IngredientsView()
                .tabItem {
                    Label("Ingredients", systemImage: "carrot")
                }
        }
        .onAppear {
            /* storage.load()*/ /// Loading data...Initial state
            
            
        }
    }
}

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TabView {
            
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
    }
}

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selectedTab = 0
    
    @State private var isRecipeNavigated = false
    @State private var isIngredientNavigated = false
    @State private var isCategoryNavigated = false
    
    @State private var path: [RecipeForm.Mode] = []
    @State private var categoryPath: [CategoryForm.Mode] = []
    @State private var ingredientPath: [IngredientForm.Mode] = []
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            RecipesView(isNavigated: $isRecipeNavigated, path: $path)
                .tabItem {
                    Label("Recipes", systemImage: "frying.pan")
                }
                .tag(0)
            
            CategoriesView(isNavigated: $isCategoryNavigated, categoryPath: $categoryPath, path: $path)
                .tabItem {
                    Label("Categories", systemImage: "tag")
                }
                .tag(1)
            
            IngredientsView(isNavigated: $isIngredientNavigated, path: $ingredientPath)
                .tabItem {
                    Label("Ingredients", systemImage: "carrot")
                }
                .tag(2)
            ShoppingCartView()
                .tabItem {
                    Label("Shopping Cart", systemImage: "cart")
                }
                .tag(3)
        }
        .onChange(of: selectedTab) { _ in
            isRecipeNavigated = false
            isCategoryNavigated = false
            isIngredientNavigated = false
            path.removeAll()
            categoryPath.removeAll()
            ingredientPath.removeAll()
        }
    }
}

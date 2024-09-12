import SwiftUI
import SwiftData

struct RecipesView: View {
    @Environment(\.modelContext) private var storage
    @Binding var isNavigated: Bool
    @Binding var path: [RecipeForm.Mode]
    @State private var query = ""
    @State private var sortOrder = SortDescriptor(\Recipe.name)
    @Query private var recipes: [Recipe]
    @State private var refreshTrigger = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Recipes")
                .toolbar {
                    if !recipes.isEmpty {
                        sortOptions
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink(value: RecipeForm.Mode.add) {
                                Label("Add", systemImage: "plus")
                            }
                        }
                    }
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode, path: $path)
                }
        }
        .onAppear {
            if !isNavigated {
                path.removeAll()
            }
        }
        .onChange(of: isNavigated) { newValue in
            if !newValue {
                path.removeAll()
            }
        }
    }
    
    // MARK: - Views
    
    @ToolbarContentBuilder
    var sortOptions: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                Picker("Sort", selection: $sortOrder) {
                    Text("Name")
                        .tag(SortDescriptor(\Recipe.name))
                    
                    Text("Serving (low to high)")
                        .tag(SortDescriptor(\Recipe.serving, order: .forward))
                    
                    Text("Serving (high to low)")
                        .tag(SortDescriptor(\Recipe.serving, order: .reverse))
                    
                    Text("Time (short to long)")
                        .tag(SortDescriptor(\Recipe.time, order: .forward))
                    
                    Text("Time (long to short)")
                        .tag(SortDescriptor(\Recipe.time, order: .reverse))
                }
            }
            .pickerStyle(.inline)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if recipes.isEmpty {
            empty
        } else {
            list(for: filteredRecipes.sorted(using: sortOrder))
        }
    }
    
    private var filteredRecipes: [Recipe] {
        let recipePredicate = #Predicate<Recipe> {
            $0.name.localizedStandardContains(query)
            ||
            $0.summary.localizedStandardContains(query)
        }
    
        let descriptor = FetchDescriptor<Recipe>(
            predicate: query.isEmpty ? nil : recipePredicate,
            sortBy: [SortDescriptor(\Recipe.name, order: .forward)]
        )
        
        do {
            let filteredRecipes = try storage.fetch(descriptor)
            return filteredRecipes
        }
        catch {
            return []
        }
    }
    
    var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Recipes", systemImage: "list.clipboard")
                    .foregroundStyle(Color.theme.accent)
            },
            description: {
                Text("Recipes you add will appear here.")
            },
            actions: {
                NavigationLink("Add Recipe", value: RecipeForm.Mode.add)
                    .buttonBorderShape(.roundedRectangle)
                    .buttonStyle(.borderedProminent)
            }
        )
    }
    
    private var noResults: some View {
        ContentUnavailableView(
            label: {
                Text("Couldn't find \"\(query)\"")
            }
        )
    }
    
    private func list(for recipes: [Recipe]) -> some View {
        ScrollView(.vertical) {
            if recipes.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(recipes, content: RecipeCell.init)
                }
            }
        }
        .searchable(text: $query)
        .id(refreshTrigger)
        .onAppear {
            refreshTrigger.toggle()
        }
    }
}

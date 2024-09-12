import SwiftUI
import SwiftData

struct IngredientsView: View {
    typealias Selection = (Ingredient) -> Void
    
    let selection: Selection?
    @Binding var ingredientPath: [IngredientForm.Mode]
    @Binding var isNavigated: Bool
    
    init(isNavigated: Binding<Bool>, path: Binding<[IngredientForm.Mode]>, selection: Selection? = nil) {
        self.selection = selection
        _isNavigated = isNavigated
        _ingredientPath = path
    }
    
    @Environment(\.modelContext) private var storage
    @Environment(\.dismiss) private var dismiss
    @State private var error: Error?
    @State private var query = ""
    @Query(sort: \Ingredient.name) private var ingredients: [Ingredient]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $ingredientPath) {
            content
                .navigationTitle("Ingredients")
                .toolbar {
                    if !ingredients.isEmpty {
                        NavigationLink(value: IngredientForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: IngredientForm.Mode.self) { mode in
                    IngredientForm(mode: mode, path: $ingredientPath)
                }
                .alert(error: $error)
        }
        .onAppear {
            if !isNavigated {
                ingredientPath.removeAll()
            }
        }
        .onChange(of: isNavigated) { newValue in
            if !newValue {
                ingredientPath.removeAll()
            }
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        if ingredients.isEmpty {
            empty
        } else {
            list(for: filteredIngredients )
        }
    }
    
    private var filteredIngredients: [Ingredient] {
        let ingredientPredicate = #Predicate<Ingredient> {
            $0.name.localizedStandardContains(query)
        }
    
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: query.isEmpty ? nil : ingredientPredicate,
            sortBy: [SortDescriptor(\Ingredient.name, order: .forward)]
        )
        
        do {
            let filteredIngredients = try storage.fetch(descriptor)
            return filteredIngredients
        }
        catch {
            return []
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Ingredients", systemImage: "list.clipboard")
                    .foregroundStyle(Color.theme.accent)
            },
            description: {
                Text("Ingredients you add will appear here.")
            },
            actions: {
                NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
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
        .listRowSeparator(.hidden)
    }
    
    private func list(for ingredients: [Ingredient]) -> some View {
        List {
            if ingredients.isEmpty {
                noResults
            } else {
                ForEach(ingredients) { ingredient in
                    row(for: ingredient)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                delete(ingredient: ingredient)
                            }
                            .tint(Color.theme.accent)
                        }
                }
            }
        }
        .searchable(text: $query)
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func row(for ingredient: Ingredient) -> some View {
        if let selection {
            Button(
                action: {
                    withAnimation {
                        selection(ingredient)
                        dismiss()
                    }
                },
                label: {
                    title(for: ingredient)
                }
            )
        } else {
            NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
                title(for: ingredient)
            }
        }
    }
    
    private func title(for ingredient: Ingredient) -> some View {
        Text(ingredient.name)
            .font(.title3)
    }
    
    // MARK: - Data
    
    private func delete(ingredient: Ingredient) {
        
        for ingredientToDelete in ingredients {
            if ingredientToDelete.id == ingredient.id {
                storage.delete(ingredient)
            }
        }
        do {
            try storage.save()
        } catch {
            self.error = .deleteError(item: error.localizedDescription)
        }
    }
}

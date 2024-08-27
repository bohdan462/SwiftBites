import SwiftUI
import SwiftData

struct IngredientForm: View {
    enum Mode: Hashable {
        case add
        case edit(Ingredient)
    }
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            title = "Add Ingredient"
        case .edit(let ingredient):
            _name = .init(initialValue: ingredient.name)
            title = "Edit \(ingredient.name)"
        }
    }
    
    private let title: String
    @State private var name: String
    @State private var error: Error?
    @Environment(\.modelContext) private var storage
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Button(
                role: .destructive,
                action: {
                    deleteAllData()
                },
                label: {
                    Text("Delete AllData")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
            Section {
                TextField("Name", text: $name)
                    .focused($isNameFocused)
            }
            if case .edit(let ingredient) = mode {
                Button(
                    role: .destructive,
                    action: {
                        delete(ingredient: ingredient)
                    },
                    label: {
                        Text("Delete Ingredient")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
            }
        }
        .onAppear {
            isNameFocused = true
        }
        .onSubmit {
            save()
        }
        .alert(error: $error)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(name.isEmpty)
            }
        }
    }
    
    // MARK: - Data
    
    private func delete(ingredient: Ingredient) {
        storage.delete(ingredient)
        try? storage.save()
        dismiss()
    }
    
    private func deleteAllData() {
        do {
                // Deleting all instances of Recipe
                let allRecipes = try storage.fetch(FetchDescriptor<Recipe>())
                for recipe in allRecipes {
                    storage.delete(recipe)
                }
                
                // Deleting all instances of RecipeIngredient
                let allRecipeIngredients = try storage.fetch(FetchDescriptor<RecipeIngredient>())
                for recipeIngredient in allRecipeIngredients {
                    storage.delete(recipeIngredient)
                }
                
                // Deleting all instances of Ingredient
                let allIngredients = try storage.fetch(FetchDescriptor<Ingredient>())
                for ingredient in allIngredients {
                    storage.delete(ingredient)
                }
                
                // Deleting all instances of Category
                let allCategories = try storage.fetch(FetchDescriptor<Category>())
                for category in allCategories {
                    storage.delete(category)
                }
                
                // Save the context to apply the deletions
                try storage.save()
            } catch {
                print("Failed to delete data: \(error.localizedDescription)")
            }
    }
    
    private func save() {
        do {
            switch mode {
            case .add:
                
                let descriptor = FetchDescriptor<Ingredient>()
                guard try (storage.fetch(descriptor).first(where: {$0.name == name }) != nil) == false else {
                    self.error = .ingredientExists
                    return
                }
                
                
                storage.insert(Ingredient(name: name))
                try storage.save()
//                storage.insert(RecipeIngredient(ingredient: Ingredient(name: name)))
            case .edit(let ingredient):
                ingredient.name = name
                try storage.save()
            }
            dismiss()
        } catch {
            self.error = error as? Error
        }
    }
}

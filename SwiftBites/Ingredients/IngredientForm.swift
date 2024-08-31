import SwiftUI
import SwiftData

struct IngredientForm: View {
    enum Mode: Hashable {
        case add
        case edit(Ingredient)
    }
    
    var mode: Mode
    
    init(mode: Mode, path: Binding<[IngredientForm.Mode]>) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            _ingredientPath = path
            title = "Add Ingredient"
        case .edit(let ingredient):
            _name = .init(initialValue: ingredient.name)
            _ingredientPath = path
            title = "Edit \(ingredient.name)"
        }
    }
    
    private let title: String
    
//    @Binding var isNavigated: Bool
    @Binding var ingredientPath: [IngredientForm.Mode]
    
    @State private var name: String
    @State private var error: Error?
    @Environment(\.modelContext) private var storage
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    @Query private var recipes: [Recipe]
    
    
    // MARK: - Body
    
    var body: some View {
        Form {
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
                .tint(Color.theme.accent)
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
    
    private func createIngredient() {
        let ingredient = Ingredient(name: name)
        print(ingredient.name)
        if !recipes.isEmpty {
            print("Recipec are not empty")
            for recipe in recipes {
                
                let missingIngredients = recipe.filter()
                
                print("we miss" , missingIngredients.count)
                for recipeIngredient in missingIngredients {
                    if recipeIngredient.name == name {
                        print("Found equal name")
                        storage.insert(ingredient)
                        recipeIngredient.ingredient = ingredient
                        do {
                            try storage.save()
                        }
                        catch {
                            self.error = .addError(item: error.localizedDescription)
                        }
                        
                    } else {
                        print("Error finding Ingredient in recipeIngredient")
                    }
                }
                print("Creating new Ingredient")
                storage.insert(ingredient)
                do {
                    try storage.save()
                }
                catch {
                    self.error = .addError(item: error.localizedDescription)
                }
                
            }
        } else {
            storage.insert(ingredient)
            do {
                try storage.save()
            }
            catch {
                self.error = .addError(item: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Data
    
    private func delete(ingredient: Ingredient) {
        
        storage.delete(ingredient)
        
        do {
            try storage.save()
        } catch {
            self.error = .deleteError(item: error.localizedDescription)
        }
        dismiss()
    }
    
    private func save() {
        
        switch mode {
        case .add:
            createIngredient()
        case .edit(let ingredient):
            ingredient.name = name
            do {
                try storage.save()
            } catch {
                self.error = .editError(item: error.localizedDescription)
            }
        }
        dismiss()
        
    }
}

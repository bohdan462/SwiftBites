import SwiftUI
import PhotosUI
import Foundation
import SwiftData

struct RecipeForm: View {
    enum Mode: Hashable {
        case add
        case edit(Recipe)
    }
    
    var mode: Mode
    
    init(mode: Mode, path: Binding<[RecipeForm.Mode]>) {
        self.mode = mode
//        _path = .init(initialValue: path)
        switch mode {
        case .add:
            title = "Add Recipe"
            _path = path
            _name = .init(initialValue: "")
            _summary = .init(initialValue: "")
            _serving = .init(initialValue: 1)
            _time = .init(initialValue: 5)
            _instructions = .init(initialValue: "")
            _recipeIngredients = .init(initialValue: [])
            _notAvailableRecipeIngredients = .init(initialValue: [])
        case .edit(let recipe):
            title = "Edit \(recipe.name)"
            _path = path
            _name = .init(initialValue: recipe.name)
            _summary = .init(initialValue: recipe.summary)
            _serving = .init(initialValue: recipe.serving)
            _time = .init(initialValue: recipe.time)
            _instructions = .init(initialValue: recipe.instructions)
            _recipeIngredients = .init(initialValue: recipe.ingredients)
            _notAvailableRecipeIngredients = .init(initialValue: recipe.filter())
            _categoryId = .init(initialValue: recipe.category?.id)
            _imageData = .init(initialValue: recipe.imageData)
            
            
        }
    }
    
    private let title: String
    
    @Binding private var path: [RecipeForm.Mode]
    
    @State private var name: String
    @State private var summary: String
    @State private var serving: Int
    @State private var time: Int
    @State private var instructions: String
    @State private var categoryId: Category.ID?
    @State private var recipeIngredients: [RecipeIngredient]
    @State private var notAvailableRecipeIngredients: [RecipeIngredient]
    @State private var imageItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var isIngredientsPickerPresented =  false
    @State private var error: Error?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var storage
    
    @Query private var categories: [Category]
    @Query private var ingredients: [Ingredient]
    
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                imageSection(width: geometry.size.width)
                nameSection
                summarySection
                categorySection
                servingAndTimeSection
                ingredientsSection
                instructionsSection
                deleteButton
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .alert(error: $error)
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
                    .disabled(name.isEmpty || instructions.isEmpty)
            }
        }
        .onChange(of: imageItem) { _, _ in
            Task {
                self.imageData = try? await imageItem?.loadTransferable(type: Data.self)
            }
        }
        .sheet(isPresented: $isIngredientsPickerPresented, content: ingredientPicker)
    }
    
    // MARK: - Views
    @MainActor
    private func ingredientPicker() -> some View {
        IngredientsView(isNavigated: .constant(false), path: .constant([])) { selectedIngredient in
            
            let existingRecipeIngredient = recipeIngredients.contains(where: {$0.name == selectedIngredient.name})
            
            guard !existingRecipeIngredient else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.error = .recipeIngredientExists
                }
                return }
            
            let recipeIngredient = RecipeIngredient(ingredient: selectedIngredient, quantity: "")
            storage.insert(recipeIngredient)
            recipeIngredients.append(recipeIngredient)
        }
        .onAppear {
            
        }
    }
    
    
    @ViewBuilder
    private func imageSection(width: CGFloat) -> some View {
        Section {
            imagePicker(width: width)
            removeImage
        }
    }
    
    @ViewBuilder
    private func imagePicker(width: CGFloat) -> some View {
        PhotosPicker(selection: $imageItem, matching: .images) {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width)
                    .clipped()
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .center)
            } else {
                Label("Select Image", systemImage: "photo")
            }
        }
    }
    
    @ViewBuilder
    private var removeImage: some View {
        if imageData != nil {
            Button(
                role: .destructive,
                action: {
                    imageData = nil
                },
                label: {
                    Text("Remove Image")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        }
    }
    
    @ViewBuilder
    private var nameSection: some View {
        Section("Name") {
            TextField("Margherita Pizza", text: $name)
        }
    }
    
    @ViewBuilder
    private var summarySection: some View {
        Section("Summary") {
            TextField(
                "Delicious blend of fresh basil, mozzarella, and tomato on a crispy crust.",
                text: $summary,
                axis: .vertical
            )
            .lineLimit(3...5)
        }
    }
    
    @ViewBuilder
    private var categorySection: some View {
        Section {
            Picker("Category", selection: $categoryId) {
                Text("None").tag(nil as Category.ID?)
                ForEach(categories) { category in
                    Text(category.name).tag(category.id as Category.ID?)
                }
            }
        }
    }
    
    @ViewBuilder
    private var servingAndTimeSection: some View {
        Section {
            Stepper("Servings: \(serving)p", value: $serving, in: 1...100)
            Stepper("Time: \(time)m", value: $time, in: 5...300, step: 5)
        }
        .monospacedDigit()
    }
    
    @ViewBuilder
    private var ingredientsSection: some View {
        Section("Ingredients") {
            if recipeIngredients.isEmpty {
                ContentUnavailableView(
                    label: {
                        Label("No Ingredients", systemImage: "list.clipboard")
                    },
                    description: {
                        Text("Recipe ingredients will appear here.")
                    },
                    actions: {
                        Button("Add Ingredient") {
                            isIngredientsPickerPresented = true
                        }
                    }
                )
            } else {
                ForEach(recipeIngredients) { ingredient in
                    HStack(alignment: .center) {
                        Text(ingredient.name)
//                            .foregroundColor((ingredient.ingredient?.name.isEmpty == false) ? .primary : .gray)
                            .foregroundColor(
                                notAvailableRecipeIngredients.contains(ingredient) ? Color.gray : Color.primary
                            )
                            .bold()
                            .layoutPriority(2)
                        Spacer()
                        TextField("Quantity", text: .init(
                            get: {
                                ingredient.quantity
                            },
                            set: { quantity in
                                if let index = recipeIngredients.firstIndex(where: { $0.id == ingredient.id }) {
                                    recipeIngredients[index].quantity = quantity
                                }
                            }
                        ))
                        .layoutPriority(1)
                    }
                }
                .onDelete(perform: deleteIngredients)
                
                Button("Add Ingredient") {
                    isIngredientsPickerPresented = true
                }
            }
        }
    }
    
    @ViewBuilder
    private var instructionsSection: some View {
        Section("Instructions") {
            TextField(
        """
        1. Preheat the oven to 475°F (245°C).
        2. Roll out the dough on a floured surface.
        3. ...
        """,
        text: $instructions,
        axis: .vertical
            )
            .lineLimit(8...12)
        }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        if case .edit(let recipe) = mode {
            Button(
                role: .destructive,
                action: {
                    delete(recipe: recipe)
                },
                label: {
                    Text("Delete Recipe")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            )
        }
    }
    
    // MARK: - Data
    private func isAvailable(_ recipe: Recipe, ingredient: RecipeIngredient) -> Bool {
        
        
        return false
    }
    
    private func delete(recipe: Recipe) {
        guard case .edit(let recipe) = mode else {
            fatalError("Delete unavailable in add mode")
        }
        
        storage.delete(recipe)
        do {
            try storage.save()
        } catch {
            self.error = .deleteError(item: error.localizedDescription)
        }
        dismiss()
    }
    
    private func deleteIngredients(offsets: IndexSet) {
        withAnimation {
            if let index = offsets.first {
                let recipeIngredient = recipeIngredients.remove(at: index)
                storage.delete(recipeIngredient)
                
            }
        }
    }
    
    private func save() {
        
        let category: Category? = categoryId.flatMap { id in categories.first(where: { $0.id == id }) }
        
        switch mode {
        case .add:
            let recipe = Recipe(name: name,
                                summary: summary,
                                category: category,
                                serving: serving,
                                time: time,
                                instructions: instructions,
                                imageData: imageData)
            
            if let category = category { category.recipes.append(recipe) }
            
            let descriptor = FetchDescriptor<Recipe>()
            guard ((try? (storage.fetch(descriptor).first(where: {$0.name == name }) != nil) == false) != nil) else {
                self.error = .recipeExists
                return
            }
            
            recipeIngredients.forEach({$0.recipe = recipe})
            recipe.ingredients = recipeIngredients
            
            storage.insert(recipe)
            
            do {
                try storage.save()
            } catch {
                self.error = .addError(item: error.localizedDescription)
            }
            
        case .edit(let recipe):
            if recipe.name != name || recipe.summary != summary ||
                recipe.category?.id != category?.id || recipe.serving != serving ||
                recipe.time != time || recipe.ingredients != recipeIngredients ||
                recipe.instructions != instructions || recipe.imageData != imageData {
                
                recipe.name = name
                recipe.summary = summary
                recipe.category = category
                recipe.serving = serving
                recipe.time = time
                recipe.instructions = instructions
                recipe.imageData = imageData
                
                recipeIngredients.forEach({recipe.ingredients.append($0)})
                recipeIngredients.forEach({$0.recipe = recipe})
                
                
                
                do {
                    try storage.save()
                } catch {
                    self.error = .editError(item: error.localizedDescription)
                }
            }
        }
        dismiss()
    }
}

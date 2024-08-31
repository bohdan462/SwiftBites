import SwiftUI
import SwiftData

struct CategoryForm: View {
    
    enum Mode: Hashable {
        case add
        case edit(Category)
    }
    
    var mode: Mode
    
    init(mode: Mode, path: Binding<[CategoryForm.Mode]>) {
        self.mode = mode
        switch mode {
        case .add:
            _name = .init(initialValue: "")
            _categoryPath = path
            title = "Add Category"
        case .edit(let category):
            _name = .init(initialValue: category.name)
            _categoryPath = path
            title = "Edit \(category.name)"
        }
    }
    
    private let title: String
    @Binding var categoryPath: [CategoryForm.Mode]
    
    @State private var name: String
    @State private var error: Error?
    
    @Environment(\.modelContext) private var storage
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .focused($isNameFocused)
            }
            if case .edit(let category) = mode {
                Button(
                    role: .destructive,
                    action: {
                        
                        delete(category: category)
                    },
                    label: {
                        Text("Delete Category")
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
    
    private func delete(category: Category) {
        storage.delete(category)
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
            do {
                let descriptor = FetchDescriptor<Category>()
                guard try (storage.fetch(descriptor).first(where: {$0.name == name }) != nil) == false else {
                    self.error = .categoryExists
                    return
                }
                storage.insert(Category(name: name))
                try storage.save()
            } catch {
                self.error = .addError(item: error.localizedDescription)
            }
        case .edit(let category):
            category.name = name
            do {
                try storage.save()
            } catch {
                self.error = .editError(item: error.localizedDescription)
            }
        }
        dismiss()
    }
}

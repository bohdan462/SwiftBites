import SwiftUI
import SwiftData

struct CategoriesView: View {
    
    @Environment(\.modelContext) private var storage
    
    @State private var query = ""
    @State private var refreshTrigger = false
    
    @Query(sort: \Category.name) private var categories: [Category]
    
    @Binding var isNavigated: Bool
    @Binding var categoryPath: [CategoryForm.Mode]
    @Binding var path: [RecipeForm.Mode]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack() {
            content
                .navigationTitle("Categories")
                .toolbar {
                    if !categories.isEmpty {
                        NavigationLink(value: CategoryForm.Mode.add) {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }
                .navigationDestination(for: CategoryForm.Mode.self) { mode in
                    
                    CategoryForm(mode: mode, path: .constant([]))
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
    
    @ViewBuilder
    private var content: some View {
        if categories.isEmpty {
            empty
        } else {
            list(for: filteredCategories)
        }
        
    }
    
    private var filteredCategories: [Category] {
        let categoryPredicate = #Predicate<Category> {
            $0.name.localizedStandardContains(query)
        }
    
        let descriptor = FetchDescriptor<Category>(
            predicate: query.isEmpty ? nil : categoryPredicate,
            sortBy: [SortDescriptor(\Category.name, order: .forward)]
        )
        
        do {
            let filteredCategories = try storage.fetch(descriptor)
            return filteredCategories
        }
        catch {
            return []
        }
    }
    
    private var empty: some View {
        ContentUnavailableView(
            label: {
                Label("No Categories", systemImage: "list.clipboard")
                    .foregroundStyle(Color.theme.accent)
            },
            description: {
                Text("Categories you add will appear here.")
            },
            actions: {
                NavigationLink("Add Category", value: CategoryForm.Mode.add)
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
    
    private func list(for categories: [Category]) -> some View {
        ScrollView(.vertical) {
            if categories.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(categories, content: CategorySection.init)
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

import SwiftUI
import SwiftData

struct CategoriesView: View {
    
    @State private var query = ""
    @Query private var categories: [Category]
    @Binding var isNavigated: Bool
    @Binding var categoryPath: [CategoryForm.Mode]
    @Binding var path: [RecipeForm.Mode]
    @State private var refreshTrigger = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack(path: $categoryPath) {
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
                    CategoryForm(mode: mode, path: $categoryPath)
                }
                .navigationDestination(for: RecipeForm.Mode.self) { mode in
                    RecipeForm(mode: mode, path: $path)
                }
        }
        .onAppear {
            if !isNavigated {
                categoryPath.removeAll()
            }
        }
        .onChange(of: isNavigated) { newValue in
            if !newValue {
                categoryPath.removeAll()
            }
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var content: some View {
        if categories.isEmpty {
            empty
        } else {
            list(for: categories.filter {
                if query.isEmpty {
                    return true
                } else {
                    return $0.name.localizedStandardContains(query)
                }
            })
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

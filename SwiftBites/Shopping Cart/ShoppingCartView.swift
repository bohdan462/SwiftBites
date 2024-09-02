//
//  ShoppingCardView.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/29/24.
//

import SwiftUI
import SwiftData

struct ShoppingCartView: View {
    
    @Environment(\.modelContext) private var storage
    @Environment(\.dismiss) private var dismiss
    
    @State private var error: Error?
    
    @Query private var ingredients: [RecipeIngredient]
    @Query(filter: #Predicate<Recipe> {
        $0.ingredients.contains(where: {$0.ingredient == nil })
    }, sort: \Recipe.name) private var recipes: [Recipe]
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                shoppingCartSection
            }
            .navigationTitle("Shopping Cart")
            .alert(error: $error)
        }
    }
    
    // MARK: - Views
    
    @ViewBuilder
    private var shoppingCartSection: some View {
        if recipes.isEmpty || filter().isEmpty {
            showContantUnavailable()
        }
        
        ForEach(recipes) { recipe in
            Section("\(recipe.filter().isEmpty ? "" : "\(recipe.name) Recipe:")") {
                ForEach(recipe.filter()) { recipeIngredient in
                    HStack(alignment: .center) {
                        Text(recipeIngredient.name)
                            .bold()
                            .layoutPriority(2)
                            .swipeActions(allowsFullSwipe: false) {
                                Button {
                                    print("Checked")
                                    createIngredient(recipeIngredient: recipeIngredient, ingredients: ingredients)
                                    
                                } label: {
                                    Label("Mute", systemImage: "checkmark")
                                }
                                .tint(Color.theme.accent)
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Data
    private func filter() -> [RecipeIngredient] {
       var output: [RecipeIngredient] = []
       
       for recipeIngredient in ingredients {
           if let _ = recipeIngredient.ingredient {
               
           } else {
               output.append(recipeIngredient)
           }
       }
       
       return output
   }
    
    private func createIngredient(recipeIngredient: RecipeIngredient, ingredients: [RecipeIngredient]) {
        let ingredient = Ingredient(name: recipeIngredient.name)
        storage.insert(ingredient)
        
        for recipeIngredient in ingredients {
            if recipeIngredient.name == ingredient.name {
                recipeIngredient.ingredient = ingredient
            }
        }
        do {
            try storage.save()
        } catch {
            
        }
    }

    private func showContantUnavailable() -> some View {
        ContentUnavailableView(
            label: {
                Label("Cart is empty", systemImage: "cart")
                    .foregroundStyle(Color.theme.accent)
            },
            description: {
                Text("Missing ingredients for your recipes will automatically appear here.")
            },
            actions: {
                
            }
        )
    }
}


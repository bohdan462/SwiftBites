//
//  RecipeIngredient.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/19/24.
//

import Foundation
import SwiftData

@Model
final class RecipeIngredient: Identifiable, Hashable {

    @Attribute(.unique) 
    let id: UUID
    @Relationship(inverse: \Recipe.ingredients)
    var recipe: Recipe?

    @Relationship
    var ingredient: Ingredient?
    let name: String = ""
    var quantity: String
    
    init(id: UUID = UUID(), ingredient: Ingredient? = nil, recipe: Recipe? = nil, quantity: String = "") {
        self.id = id
        self.ingredient = ingredient
        self.recipe = recipe
        self.quantity = quantity
        self.name = ingredient?.name ?? "Something Went Wrong"
    }
    
    func printDetails() {
            print("RecipeIngredient Details:")
            print("Ingredient Name: \(ingredient?.name ?? "Unknown Ingredient")")
            print("Quantity: \(quantity)")
        }
    
    
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

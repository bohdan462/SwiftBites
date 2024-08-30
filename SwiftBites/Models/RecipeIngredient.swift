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
    @Relationship(deleteRule: .nullify)
    var ingredient: Ingredient?
    let name: String = ""
    var quantity: String
    
    init(id: UUID = UUID(), ingredient: Ingredient?, recipe: Recipe? = nil, quantity: String = "") {
        self.id = id
        self.ingredient = ingredient
        self.recipe = recipe
        self.quantity = quantity
        self.name = ingredient?.name ?? ""
    }
    
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

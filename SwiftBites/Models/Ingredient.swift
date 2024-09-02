//
//  Ingredient.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/19/24.
//

import Foundation
import SwiftData

@Model
final class Ingredient: Identifiable, Hashable {
    
    @Attribute(.unique) 
    let id: UUID
    
    @Attribute
    var name: String
    
    var available: Bool
    
    @Relationship(deleteRule: .nullify, inverse: \RecipeIngredient.ingredient)
    private var recipeIngredients: [RecipeIngredient]?
    
    init(id: UUID = UUID(), name: String = "", available: Bool = false, recipeIngredients: [RecipeIngredient]? = []) {
        self.id = id
        self.name = name.capitalized
        self.available = available
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

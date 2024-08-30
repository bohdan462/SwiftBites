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

    @Attribute let id: UUID
    
    @Attribute
     var name: String
    
//    @Relationship(deleteRule: .nullify) var recipeIngredients: [RecipeIngredient]?

    init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

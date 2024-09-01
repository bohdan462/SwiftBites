//
//  Recipe.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/19/24.
//

import Foundation
import SwiftData

@Model
final class Recipe: Identifiable, Hashable {
    
    @Attribute(.unique)
     let id: UUID

    @Relationship
    var category: Category?
    @Attribute(.unique)
    var name: String
    var summary: String
    var serving: Int
    var time: Int
    
    @Relationship(deleteRule: .cascade)
    var ingredients: [RecipeIngredient]
    
    var instructions: String
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        name: String = "",
        summary: String = "",
        category: Category? = nil,
        serving: Int = 1,
        time: Int = 5,
        ingredients: [RecipeIngredient] = [],
        instructions: String = "",
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
    
     func filter() -> [RecipeIngredient] {
        var output: [RecipeIngredient] = []
        
        for recipeIngredient in ingredients {
            if let _ = recipeIngredient.ingredient {
                
            } else {
                output.append(recipeIngredient)
            }
        }
        
        return output
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

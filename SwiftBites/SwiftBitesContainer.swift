//
//  SwiftBitesContainer.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/19/24.
//

import Foundation
import SwiftData
import SwiftUI

enum Error: LocalizedError {
    case ingredientExists
    case categoryExists
    case recipeExists
    case recipeIngredient

    var errorDescription: String? {
      switch self {
      case .ingredientExists:
        return "Ingredient with the same name exists"
      case .categoryExists:
        return "Category with the same name exists"
      case .recipeExists:
        return "Recipe with the same name exists"
      case .recipeIngredient:
        return "Recipe Ingredient with the same name exists"
      }
    }
  }

class SwiftBitesContainer {

    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema([Category.self, Recipe.self, RecipeIngredient.self, Ingredient.self])
        let configuration = ModelConfiguration("SwiftBites", schema: schema)
        
        do {
            let container = try ModelContainer(for: schema, configurations: configuration)
//            if isEmpty(context: container.mainContext) {
//        
//                let (ingredients, categories, recipeIngredients, recipes) = mockData()
//                
//                // Inserting mock data into the context
//                categories.forEach { container.mainContext.insert($0 as Category) }
//                recipes.forEach { container.mainContext.insert($0 as Recipe) }
//                ingredients.forEach { container.mainContext.insert($0 as Ingredient) }
////                recipeIngredients.forEach { container.mainContext.insert($0 as RecipeIngredient)}
//                
//                
//                                do {
//                                    try container.mainContext.save()
//                                } catch {
//                                    fatalError("Error saving mock data: \(error)")
//                                }
//                
//                
//            }
            return container
        } catch {
            fatalError("Error creating Model Container: \(error)")
        }
        
    }
    
    
    
    private static func isEmpty(context: ModelContext) -> Bool {
        let descriptor = FetchDescriptor<Category>()
        
        do {
            let existingCategory = try context.fetch(descriptor)
            return existingCategory.isEmpty
        } catch {
            return false
        }
    }
    
    private static func mockData() -> ([Ingredient], [Category], [RecipeIngredient], [Recipe]) {
        
        let italian = Category(name: "Italian")
        let middleEastern = Category(name: "Middle Eastern")
        
        let pizzaDough = Ingredient(name: "Pizza Dough")
        let tomatoSauce = Ingredient(name: "Tomato Sauce")
        let mozzarellaCheese = Ingredient(name: "Mozzarella Cheese")
        let freshBasilLeaves = Ingredient(name: "Fresh Basil Leaves")
        let extraVirginOliveOil = Ingredient(name: "Extra Virgin Olive Oil")
        let salt = Ingredient(name: "Salt")
        
        let recipeIngredients = [
            RecipeIngredient(ingredient: pizzaDough, quantity: "1 ball"),
            RecipeIngredient(ingredient: tomatoSauce, quantity: "1/2 cup"),
            RecipeIngredient(ingredient: mozzarellaCheese, quantity: "1 cup, shredded"),
            RecipeIngredient(ingredient: freshBasilLeaves, quantity: "A handful"),
            RecipeIngredient(ingredient: extraVirginOliveOil, quantity: "2 tablespoons"),
            RecipeIngredient(ingredient: salt, quantity: "Pinch"),
        ]
        
        let margherita = Recipe(
            name: "Classic Margherita Pizza",
            summary: "A simple yet delicious pizza with tomato, mozzarella, basil, and olive oil.",
            category: italian,
            serving: 4,
            time: 50,
            ingredients: recipeIngredients,
            instructions: "Preheat oven, roll out dough, apply sauce, add cheese and basil, bake for 20 minutes.",
            imageData: UIImage(named: "margherita")?.pngData()
        )
        
        
        let ingredients: [Ingredient] = [pizzaDough,
                                         tomatoSauce,
                                         mozzarellaCheese,
                                         freshBasilLeaves,
                                         extraVirginOliveOil,
                                         salt]
        let categories: [Category] = [italian,
                                      middleEastern]
        let recipes: [Recipe] = [margherita]
        
       // italian.recipes.append(margherita)
        
        return (ingredients, categories,recipeIngredients, recipes)
    }
}

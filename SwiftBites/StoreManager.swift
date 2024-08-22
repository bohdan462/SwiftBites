//
//  StoreManager.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/21/24.
//

import Foundation
import SwiftData

class StoreManager<T> {
    
    
    
    
    ///CRUD
    ///Create
    ///Read
    ///Update
    ///Delete
    ///
    ///
    // MARK: - Categories
    //
    func addCategory(name: String, store: ModelContext, categories: [Category] )  {
        guard categories.contains(where: { $0.name == name }) == false else {
            fatalError()
        }
        //       categories.append(Category(name: name))
        store.insert(Category(name: name))
    }
    //
    //  func deleteCategory(id: MockCategory.ID) {
    //    categories.removeAll(where: { $0.id == id })
    //    for (index, recipe) in recipes.enumerated() where recipe.category?.id == id {
    //      recipes[index].category = nil
    //    }
    //  }
    //
    //  func updateCategory(id: MockCategory.ID, name: String) throws {
    //    guard categories.contains(where: { $0.name == name && $0.id != id }) == false else {
    //      throw Error.categoryExists
    //    }
    //    guard let index = categories.firstIndex(where: { $0.id == id }) else {
    //      return
    //    }
    //    categories[index].name = name
    //    for (index, recipe) in recipes.enumerated() where recipe.category?.id == id {
    //      recipes[index].category?.name = name
    //    }
    //  }
    //
    //  // MARK: - Ingredients
    //
    //  func addIngredient(name: String) throws {
    //    guard ingredients.contains(where: { $0.name == name }) == false else {
    //      throw Error.ingredientExists
    //    }
    //    ingredients.append(MockIngredient(name: name))
    //  }
    //
    //  func deleteIngredient(id: MockIngredient.ID) {
    //    ingredients.removeAll(where: { $0.id == id })
    //  }
    //
    //  func updateIngredient(id: MockIngredient.ID, name: String) throws {
    //    guard ingredients.contains(where: { $0.name == name && $0.id != id }) == false else {
    //      throw Error.ingredientExists
    //    }
    //    guard let index = ingredients.firstIndex(where: { $0.id == id }) else {
    //      return
    //    }
    //    ingredients[index].name = name
    //  }
    //
    //  // MARK: - Recipes
    //
    //  func addRecipe(
    //    name: String,
    //    summary: String,
    //    category: MockCategory?,
    //    serving: Int,
    //    time: Int,
    //    ingredients: [MockRecipeIngredient],
    //    instructions: String,
    //    imageData: Data?
    //  ) throws {
    //    guard recipes.contains(where: { $0.name == name }) == false else {
    //      throw Error.recipeExists
    //    }
    //    let recipe = MockRecipe(
    //      name: name,
    //      summary: summary,
    //      category: category,
    //      serving: serving,
    //      time: time,
    //      ingredients: ingredients,
    //      instructions: instructions,
    //      imageData: imageData
    //    )
    //    recipes.append(recipe)
    //    if let category, let index = categories.firstIndex(where: { $0.id == category.id }) {
    //      categories[index].recipes.append(recipe)
    //    }
    //  }
    //
    //  func deleteRecipe(id: MockRecipe.ID) {
    //    recipes.removeAll(where: { $0.id == id })
    //    for cIndex in categories.indices {
    //      categories[cIndex].recipes.removeAll(where: { $0.id == id })
    //    }
    //  }
    //
    //  func updateRecipe(
    //    id: MockRecipe.ID,
    //    name: String,
    //    summary: String,
    //    category: MockCategory?,
    //    serving: Int,
    //    time: Int,
    //    ingredients: [MockRecipeIngredient],
    //    instructions: String,
    //    imageData: Data?
    //  ) throws {
    //    guard recipes.contains(where: { $0.name == name && $0.id != id }) == false else {
    //      throw Error.recipeExists
    //    }
    //    guard let index = recipes.firstIndex(where: { $0.id == id }) else {
    //      return
    //    }
    //    let recipe = MockRecipe(
    //      id: id,
    //      name: name,
    //      summary: summary,
    //      category: category,
    //      serving: serving,
    //      time: time,
    //      ingredients: ingredients,
    //      instructions: instructions,
    //      imageData: imageData
    //    )
    //    recipes[index] = recipe
    //    for cIndex in categories.indices {
    //      categories[cIndex].recipes.removeAll(where: { $0.id == id })
    //    }
    //    if let cIndex = categories.firstIndex(where: { $0.id == category?.id }) {
    //      categories[cIndex].recipes.append(recipe)
    //    }
    //  }
    //}
    
    //struct StorageKey: EnvironmentKey {
    //  static let defaultValue = Storage()
    //}
    
    
    //extension EnvironmentValues {
    //  var storage: Storage {
    //    get { self[StorageKey.self] }
    //    set { self[StorageKey.self] = newValue }
    //  }
    //}
    //   */
    
}

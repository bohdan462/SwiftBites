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
    enum CodingKeys: String, CodingKey {
        case id, name, summary, category, serving, time, ingredients, instructions, imageData
    }
    
    @Attribute(.unique) let id: UUID
    var name: String
    var summary: String
    
    //Relationship
    @Relationship
    var category: Category?
    
    var serving: Int
    var time: Int
    
    //Relationship
    @Relationship(deleteRule: .nullify)
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
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
//    ///Decodable
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.summary = try container.decode(String.self, forKey: .summary)
//        self.category = try container.decode(Category.self, forKey: .category)
//        self.serving = try container.decode(Int.self, forKey: .serving)
//        self.time = try container.decode(Int.self, forKey: .time)
//        self.ingredients = try container.decode([RecipeIngredient].self, forKey: .ingredients)
//        self.instructions = try container.decode(String.self, forKey: .instructions)
//        self.imageData = try container.decode(Data.self, forKey: .imageData)
//    }
//    
//    
//    ///Encodable
//    func encode(to encoder: Encoder) throws {
//        var conteiner = encoder.container(keyedBy: CodingKeys.self)
//        try conteiner.encode(id, forKey: .id)
//        try conteiner.encode(name, forKey: .name)
//        try conteiner.encode(summary, forKey: .summary)
//        try conteiner.encode(category, forKey: .category)
//        try conteiner.encode(serving, forKey: .serving)
//        try conteiner.encode(time, forKey: .time)
//        try conteiner.encode(ingredients, forKey: .ingredients)
//        try conteiner.encode(instructions, forKey: .instructions)
//        try conteiner.encode(imageData, forKey: .imageData)
//        
//    }
}

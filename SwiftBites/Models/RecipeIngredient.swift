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
    enum CodingKeys: String, CodingKey {
        case id, ingredient, quantity
    }
    
    @Attribute(.unique) let id: UUID
    
    //Relationship?
    @Relationship(deleteRule: .nullify)
    var ingredient: Ingredient
    
    var quantity: String
    
    init(id: UUID = UUID(), ingredient: Ingredient = Ingredient(), quantity: String = "") {
        self.id = id
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
//    ///Decodable
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.ingredient = try container.decode(Ingredient.self, forKey: .ingredient)
//        self.quantity = try container.decode(String.self, forKey: .quantity)
//    }
//    
//    
//    ///Encodable
//    func encode(to encoder: Encoder) throws {
//        var conteiner = encoder.container(keyedBy: CodingKeys.self)
//        try conteiner.encode(id, forKey: .id)
//        try conteiner.encode(ingredient, forKey: .ingredient)
//        try conteiner.encode(quantity, forKey: .quantity)
//        
//    }
}

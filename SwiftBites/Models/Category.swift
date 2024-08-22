//
//  Category.swift
//  SwiftBites
//
//  Created by Bohdan Tkachenko on 8/19/24.
//

import Foundation
import SwiftData

@Model
final class Category: Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case recipes
    }
    
    @Attribute(.unique) let id: UUID
    var name: String
    
    //Relationship
    @Relationship(deleteRule: .nullify, inverse: \Recipe.category)
    var recipes: [Recipe]
    
    init(id: UUID = UUID(), name: String = "", recipes: [Recipe] = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
    static func == (lhs: Category, rhs: Category) -> Bool {
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
//        self.recipes = try container.decode([Recipe].self, forKey: .recipes)
//    }
//    
//    
//    ///Encodable
//    func encode(to encoder: Encoder) throws {
//        var conteiner = encoder.container(keyedBy: CodingKeys.self)
//        try conteiner.encode(id, forKey: .id)
//        try conteiner.encode(name, forKey: .name)
//        try conteiner.encode(recipes, forKey: .recipes)
//        
//    }
}

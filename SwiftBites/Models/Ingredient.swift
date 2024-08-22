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
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    let id: UUID
    
  
    var name: String
    
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
    
//    ///Decodable
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(UUID.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//    }
//    
//    
//    ///Encodable
//    func encode(to encoder: Encoder) throws {
//        var conteiner = encoder.container(keyedBy: CodingKeys.self)
//        try conteiner.encode(id, forKey: .id)
//        try conteiner.encode(name, forKey: .name)
//        
//    }
}

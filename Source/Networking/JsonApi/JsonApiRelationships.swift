//
//  JsonApiRelationships.swift
//  SpinAndWin
//
//  Created by Cam on 11/11/21.
//

import Foundation
import SwiftyJSON

struct JsonApiRelationships: Codable {
  var relationships: [JsonApiRelationship]
  
  enum CodingKeys: String, CodingKey {
    case relationships
  }
  
  init(array: [JsonApiModel]) {
    relationships = array.map { JsonApiRelationship(model: $0) }
  }
  
  init(from decoder: Decoder) throws {
    let json = try JSON(from: decoder)
    var relations: [JsonApiRelationship] = []
    for relation in json["relationships"].dictionaryValue {
      relations.append(try JsonApiRelationship(from: relation))
    }
    relationships = relations
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    var relations = JSON()
    for relation in relationships {
      let data: [String: Any] = ["type": relation.type.rawValue, "id": relation.id]
      let relationData = JSON(["data": data])
      relations[relation.type.singular] = relationData
    }
    try container.encode(relations)
  }
}

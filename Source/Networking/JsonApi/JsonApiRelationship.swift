//
//  JsonApiRelationship.swift
//  SpinAndWin
//
//  Created by Cam on 11/11/21.
//

import Foundation
import SwiftyJSON

struct JsonApiRelationship {
  let id: String
  let type: JsonApiResource
  
  init(from json: (key: String, value: JSON)) throws {
    self.id = json.value["id"].stringValue
    if let type = JsonApiResource(rawValue: json.value["type"].stringValue) {
      self.type = type
    } else {
      throw AlertError(title: "Failed to create JsonApiResource from \(json.value["type"].stringValue)")
    }
  }
  
  init(model: JsonApiModel) {
    self.id = model.id
    self.type = model.type
  }
}

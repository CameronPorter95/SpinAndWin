//
//  JsonApiModel.swift
//  SpinAndWin
//
//  Created by Cam on 11/11/21.
//

import Foundation

protocol JsonApiModel: Codable {
  var id: String { get set }
  var type: JsonApiResource { get }
  var relationships: JsonApiRelationships? { get set }
}

extension JsonApiModel {
  ///Map JsonApiModel to a form that can be used to make a JsonApi request
  var jsonApiBody: [String: Any]? {
    let dictionary = self.dictionary
    let attributes: [String: Any]? = dictionary?.filter { $0.key != "id" && $0.key != "type" && $0.key != "relationships" }
    var data: [String: Any]? = dictionary?.filter { $0.key == "type" || $0.key == "relationships" }
    data?["attributes"] = attributes
    guard let d = data else { return nil }
    return ["data": d] as [String: Any]
  }
}

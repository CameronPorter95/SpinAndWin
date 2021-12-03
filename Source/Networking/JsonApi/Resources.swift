//
//  Resources.swift
//  SpinAndWin
//
//  Created by Cam on 11/11/21.
//

import Foundation

indirect enum JsonApiResource: RawRepresentable, Codable, CaseIterable {
  case redemptions(JsonApiResource? = nil)
  case prizes(JsonApiResource? = nil)
  
  init?(rawValue: String) {
    if let resource = JsonApiResource.allCases.first(where: { $0.rawValue == rawValue }) {
      self = resource
    } else {
      return nil
    }
  }
  
  init(from decoder: Decoder) throws {
    let value = try decoder.singleValueContainer()
    let rawValue = try value.decode(String.self)
    if JsonApiResource.allCases.map({ $0.rawValue }).contains(rawValue) {
      self.init(rawValue: rawValue)!
    } else {
      throw AlertError(title: "Failed to initialise JsonApiResource from \(rawValue)")
    }
  }
  
  var rawValue: String {
    switch self {
    case .redemptions:
      return "redemptions"
    case .prizes:
      return "prizes"
    }
  }
  
  var singular: String {
    let getSingular: (String, JsonApiResource?) -> String = { singular, resource in
      guard let resource = resource else {
        return singular
      }
      return "\(singular).\(resource.singular)"
    }
    switch self {
    case .redemptions(let resource):
      return getSingular("redemption", resource)
    case .prizes(let resource):
      return getSingular("prize", resource)
    }
  }
  
  static var allCases: [JsonApiResource] {
    return [
      .redemptions(),
      .prizes()
    ]
  }
}

extension Array where Element == JsonApiResource {
  var rawValues: [String] {
    return map { $0.rawValue }
  }
  
  var singulars: [String] {
    return map { $0.singular }
  }
}

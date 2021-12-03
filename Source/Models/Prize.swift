//
//  Prize.swift
//  SpinAndWin
//

import Foundation

struct Prize: Codable {
  var category: Wheel.Section?
  
  enum CodingKeys: String, CodingKey {
    case category = "category"
  }
}

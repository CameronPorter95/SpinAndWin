//
//  Redemption.swift
//  SpinAndWin
//

import Foundation

struct Redemption: Codable {
  var prize: Prize?
  
  enum CodingKeys: String, CodingKey {
    case prize = "prize"
  }
}

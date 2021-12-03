//
//  ModelWrapper.swift
//  SpinAndWin
//
//  Created by Cam on 3/12/21.
//

import Foundation

struct ModelWrapper<T>: Codable where T: Codable {
  var status: String?
  var code: Int?
  var data: T?

  init(data: T) {
    self.data = data
  }
}

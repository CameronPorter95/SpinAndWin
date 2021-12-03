//
//  AlertError.swift
//  SpinAndWin
//
//  Created by Cam on 3/12/21.
//

import UIKit

typealias AlertAction = (title: String, isBlockable: Bool, handler: (() -> ())?)

struct AlertError: Swift.Error {
  var title: String
  var message: String?
  var code: Int?
  var image: UIImage?

  init(title: String, message: String? = nil, code: Int? = nil, image: UIImage? = nil) {
    self.title = title
    self.message = message
    self.code = code
    self.image = image
  }
}

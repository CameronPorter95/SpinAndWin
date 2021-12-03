//
//  UIViewController.swift
//  SpinAndWin
//
//  Created by Cam on 3/12/21.
//

import Foundation
import UIKit

//typealias AlertAction = (title: String, isBlockable: Bool, handler: (() -> ())?)
//
//extension UIViewController {
//  @discardableResult func withAlert<T>(actions a: [AlertAction] = [],
//  handler h: (() -> ())? = nil,
//  throwing: () throws -> T) -> T? {
//    do {
//      return try throwing()
//    } catch {
//      let errorObject: JsonApiErrors? = error.decode()
//      if let errors = errorObject?.errors {
//        let alertErrors = errors.map { AlertError(title: $0.title ?? "", message: $0.detail, code: Int($0.status!), image: nil) }
//        alertErrors.forEach { handle($0, actions: a, handler: h) }
//        return nil
//      }
//      handle(error, actions: a, handler: h)
//      return nil
//    }
//  }
//}

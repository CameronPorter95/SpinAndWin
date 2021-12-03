//
//  ErrorReportable.swift
//  SpinAndWin
//

import Foundation
import Moya
import SwiftyJSON

///Allows errors to be reported to crashlytics and displayed in an error pop up on a given view controller
protocol ErrorReportable { }

extension ErrorReportable {
  func notifyError(error: Error, sender: UIViewController?, callback: (() -> ())? = nil) {
    if let controller = sender {
//      controller.withAlert(actions: [], handler: callback, throwing: {
//        throw error
//      })
    }
  }
}

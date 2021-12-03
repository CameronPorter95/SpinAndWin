//
//  BackendConstants.swift
//  SpinAndWin
//

import Foundation

struct BackendConstants {
  static var prodIPAddress: String {
    return Bundle.main.object(forInfoDictionaryKey: "ProductionIPAddress") as! String
  }
  
  static var localhostIPAddress: String {
    return Bundle.main.object(forInfoDictionaryKey: "LocalhostIPAddress") as? String ?? "localhost"
  }
}

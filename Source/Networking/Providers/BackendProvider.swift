//
//  BackendProvider.swift
//  SpinAndWin
//

import Foundation
import Moya
import Result
import BrightFutures
import Alamofire

class BackendProvider: MoyaProvider<BackendRequest> {
  lazy var spinAndWinProvider: SpinAndWinProvider = {
     return SpinAndWinProvider(provider: self)
  }()

  init(plugins: [PluginType] = []) {
    super.init(plugins: plugins)
  }

  /// This isn't a singleton for testing purposes that allows to get a stub
  /// instance
  static func instance() -> BackendProvider {
    var ps: [PluginType] = [
      NetworkActivityPlugin { change, _ in
        UIApplication.shared.isNetworkActivityIndicatorVisible =
          change == .began
      }
    ]
#if DEBUG
    ps.append(NetworkLoggerPlugin(verbose: true, cURL: true))
#endif
    return BackendProvider(plugins: ps)
  }
}

//
//  Requestable.swift
//  SpinAndWin
//

import Foundation
import Moya
import BrightFutures

///Allows making requests
protocol Requestable {
  associatedtype Request: BackendRequest
  func getProvider() -> MoyaProvider<Request>
}

extension Requestable {
  func future(_ target: Request?) -> MoyaFuture<Moya.Response> {
    guard let target = target else {
      return Future { complete in
        complete(.failure(MoyaError.parameterEncoding(AlertError(title: "Request Parameters are missing."))))
      }
    }
    let future = Future { complete in
      getProvider().request(target) {
        complete($0)
      }
    }
    return future
  }
}

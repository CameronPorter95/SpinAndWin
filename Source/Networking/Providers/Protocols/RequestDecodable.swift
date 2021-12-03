//
//  RequestDecodable.swift
//  SpinAndWin
//

import Foundation
import Moya
import Result
import BrightFutures

///Allows making requests and decoding them into swift codables
protocol RequestDecodable: AnyObject, Requestable {
  var provider: BackendProvider! { get }
}

extension RequestDecodable {
  func futureObject<U: Codable>(_ target: Request?) -> MoyaFuture<U> {
    return future(target).flatMap { r -> MoyaResult<U> in
      let result: MoyaResult<U> = r.flattened.mapObject().flatMap { (br: ModelWrapper<U>) in
        guard let data = br.data else {
          return Result(error: MoyaError.jsonMapping(r))
        }
        return Result(value: data)
      }
      return result
    }
  }
}

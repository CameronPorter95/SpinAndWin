//
//  Response.swift
//  SpinAndWin
//
//  Created by Cam on 3/12/21.
//

import Foundation
import Japx
import BrightFutures
import Moya
import Result

typealias MoyaFuture<T> = Future<T, MoyaError>
typealias MoyaResult<T> = Result<T, MoyaError>

extension Response {
  func mapObject<T: Decodable>() -> MoyaResult<T> {
    do {
      return Result(value: try map(T.self))
    } catch let e as MoyaError {
      return Result(error: e)
    } catch {
      return Result(error: MoyaError.underlying(error, nil))
    }
  }
  
  ///Flattens a JSONAPI response so it can be decoded normally
  var flattened: Response {
    guard let flattenedData = try? Japx.Decoder.data(with: self.data) else {
      return self
    }
    return Response(statusCode: statusCode, data: flattenedData, request: request, response: response)
  }
}

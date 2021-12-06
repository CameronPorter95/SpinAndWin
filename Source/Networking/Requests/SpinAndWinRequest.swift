//
//  SpinAndWinRequest.swift
//  SpinAndWin
//
//  Created by Cam on 19/03/21.
//

import Foundation
import Moya
import Alamofire

class SpinAndWinRequest: BackendRequest {
  static func spinWheel() -> SpinAndWinRequest? {
    let attributes = ["": ""] as [String : Any]
    let data = [
      "type": "redemptions",
      "attributes": attributes] as [String : Any]
    let p = ["data": data] as [String : Any]
    let headers = ["Accept": "application/json"]
    let urlParams = ["include": "prize"]
    let path = getRandomStubPrize(for: .redemption(nil))
    return SpinAndWinRequest(path: path, method: .post, parameters: p, headers: headers, compositeParameters: urlParams)
  }
  
  ///Only for stubbing
  static func getRandomStubPrize(for path: BackendPath) -> BackendPath {
  #if NETWORK_STUBS_ENABLED
    let rand = Int.random(in: 1..<100)
    if rand > 99 {
      return .redemption("scooter")
    } else if rand > 94 {
      return .redemption("200_off")
    } else if rand > 84 {
      return .redemption("5_free_transfer")
    } else if rand > 69 {
      return .redemption("4_free_transfer")
    } else if rand > 49 {
      return .redemption("3_free_transfer")
    } else if rand > 24 {
      return .redemption("2_free_transfer")
    } else {
      return .redemption("free_transfer")
    }
  #else
    return path
  #endif
  }
}

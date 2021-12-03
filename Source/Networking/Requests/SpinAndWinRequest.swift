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
    return SpinAndWinRequest(path: .redemption, method: .post, parameters: p, headers: headers, compositeParameters: urlParams)
  }
}

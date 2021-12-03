//
//  BackendRequest.swift
//  SpinAndWin
//

import Foundation
import Moya
import Alamofire

enum BackendPath: CustomStringConvertible {
  case redemption

  var description: String {
    switch self {
    case .redemption:
      return "v3/redemptions"
    }
  }
}

class BackendRequest: TargetType {
  static var stub = false
  static var stubFailure = false
  
  var headers: [String : String]?
  var backendPath: BackendPath
  var parameters: [String : Any]?
  var method: HTTPMethod
  var task: Task
  var parameterEncoding: ParameterEncoding
  var path: String {
    get { backendPath.description }
  }
  
  static var jsonApiHeaders: [String : String] {
    return [
      "Content-Type": "application/vnd.api+json",
      "Accept": "application/vnd.api+json"
    ]
  }

  init(path: BackendPath,
       method: HTTPMethod = .get,
       parameters: [String: Any]? = [:],
       includes: [String]? = nil,
       filters: [String: String]? = nil,
       fields: [String: String]? = nil,
       headers: [String: String]? = nil,
       compositeParameters: [String: Any]? = nil, //If making a json encoded request with query parameters, put the query parameters in compositeParameters
       parameterEncoding: ParameterEncoding = JSONEncoding()) {
    var parameters = parameters
    self.backendPath = path
    self.method = method
    filters?.forEach { parameters?["filter[\($0.key)]"] = $0.value }
    fields?.forEach { parameters?["fields[\($0.key)]"] = $0.value }
    if let includes = includes {
      parameters?["include"] = includes.joined(separator: ",")
    }
    self.parameters = parameters
    self.headers = headers
    if let p = parameters, !p.isEmpty {
      self.task = compositeParameters != nil ? .requestCompositeParameters(bodyParameters: p, bodyEncoding: parameterEncoding, urlParameters: compositeParameters!)
        : .requestParameters(parameters: p, encoding: parameterEncoding)
    } else {
      self.task = .requestPlain
    }
    self.parameterEncoding = parameterEncoding
  }
  
  var prodURL: URL { URL(string: "https://\(BackendConstants.prodIPAddress)/")! }
  var stubURL: URL { URL(string: "http://\(BackendConstants.localhostIPAddress):8080/")! }
  var baseURL: URL {
    #if NETWORK_STUBS_ENABLED
    return stubURL
    #else
    return prodURL
    #endif
  }

  func requestKey(shouldContainParameters: Bool = false, getFail: Bool = false) -> String {
    var key = path.replacingOccurrences(of: "/", with: ".")
    key.append(".\(method.rawValue)")

    if shouldContainParameters,
    let dict = parameters as? [String: CustomStringConvertible] {
      var c = URLComponents()

      c.queryItems = dict.map { (k, v) in
        return URLQueryItem(name: k, value: v.description)
      }

      if let paremetersString = c.string {
        key.append(paremetersString)
      }
    }
    return getFail ? key.appending(".fail") : key
  }

  var sampleData: Data {
    let url = Bundle.main.url(forResource: requestKey(), withExtension: "json")!
    return try! Data(contentsOf: url)
  }
}

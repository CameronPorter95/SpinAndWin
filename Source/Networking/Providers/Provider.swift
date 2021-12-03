//
//  Provider.swift
//  SpinAndWin
//

import Foundation
import Moya

class Provider<T: BackendRequest>: MoyaProvider<T>, Requestable {
  weak var provider: BackendProvider!
  var delegates = NSHashTable<AnyObject>.weakObjects()
  
  init(provider: BackendProvider) {
    let endpointClosure: EndpointClosure
    if BackendRequest.stubFailure {
      endpointClosure = { (target: BackendRequest) -> Endpoint in
        let url = URL(target: target).absoluteString
        return Endpoint(url: url, sampleResponseClosure: {.networkError(NSError(domain: "Test Failure", code: 500))},
                        method: target.method, task: target.task, httpHeaderFields: target.headers)
      }
    } else {
      endpointClosure = { (target: BackendRequest) -> Endpoint in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        return defaultEndpoint
      }
    }
    
    super.init(endpointClosure: endpointClosure,
               stubClosure: BackendRequest.stub ? MoyaProvider.immediatelyStub : MoyaProvider.neverStub,
               plugins: provider.plugins)
    self.provider = provider
  }
  
  internal func getProvider() -> MoyaProvider<T> {
    self
  }
}


//
//  DesignatableProvider.swift
//  SpinAndWin
//

import Foundation

///Allows a provider to designate delegates
protocol DesignatableProvider {
  var delegates: NSHashTable<AnyObject> { get set }
}

extension DesignatableProvider {
  func addToDelegates(_ delegate: ProviderDelegate) {
    if !delegates.contains(delegate) {
      delegates.add(delegate)
    }
  }
  
  func addToDelegates(contentsOf delegates: [ProviderDelegate]) {
    for delegate in delegates where !self.delegates.contains(delegate) {
      self.delegates.add(delegate)
    }
  }
  
  func retrieveFromDelegates(_ delegate: ProviderDelegate) -> ProviderDelegate? {
    if let result = delegates.member(delegate) as? ProviderDelegate {
      return result
    }
    return nil
  }
  
  var allDelegates: [ProviderDelegate] {
    return delegates.allObjects as! [ProviderDelegate]
  }
}

//
//  ProviderController.swift
//  SpinAndWin
//

import UIKit
import Moya

protocol Providable: ProviderMixin where Self: UIViewController {
  var backendProvider: BackendProvider? { get set }
}

extension Providable {
  func prepareForSegue(segue: UIStoryboardSegue) {
    passProvider(segue.destination)
  }
}

protocol ProviderMixin: class {
  var backendProvider: BackendProvider? { get set }
}

extension ProviderMixin {
  func passProvider(_ destination: UIViewController) {
    var destination = destination

    if let navigation = destination as? UINavigationController,
      let top = navigation.topViewController {
      destination = top
    }

    guard let next = destination as? ProviderMixin,
    let provider = backendProvider else {
      return
    }

    next.backendProvider = provider
  }
}

/// Base controller class that facilitates dependecy injection of 
/// `BackendProvider` instances through segues
class ProviderController: UIViewController, Providable {
  var backendProvider: BackendProvider?
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    prepareForSegue(segue: segue)
  }
}

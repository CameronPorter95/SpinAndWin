//
//  SpinAndWinProvider.swift
//  SpinAndWin
//

import Foundation
import Moya
import BrightFutures

class SpinAndWinProvider: Provider<SpinAndWinRequest>, RequestDecodable, ErrorReportable, DesignatableProvider {
  var section: Wheel.Section?
  
  @discardableResult func spinWheel(sender: Any? = nil) -> MoyaFuture<Redemption> {
    allDelegates.forEach { ($0 as? SpinAndWinDelegate)?.spinWheelDidBegin() }
    return futureObject(.spinWheel())
    .onSuccess { (redemption: Redemption) in
      self.section = redemption.prize?.category
      guard let section = redemption.prize?.category else { return }
      self.allDelegates.forEach { ($0 as? SpinAndWinDelegate)?.spinWheelDidSucceed(section) }
    }.onFailure { e in
      self.notifyError(error: e, sender: sender as? UIViewController)
      self.allDelegates.forEach { ($0 as? SpinAndWinDelegate)?.spinWheelDidFail(error: e) }
    }
  }
}

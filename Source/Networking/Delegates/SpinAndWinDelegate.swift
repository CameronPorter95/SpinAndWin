//
//  ChristmasCardsDelegate.swift
//  SpinAndWin
//

import Foundation
import Moya

protocol SpinAndWinDelegate: ProviderDelegate {
  func spinWheelDidBegin()
  func spinWheelDidSucceed(_ section: Wheel.Section)
  func spinWheelDidFail(error: MoyaError)
}

extension SpinAndWinDelegate {
  func spinWheelDidBegin() { }
  func spinWheelDidSucceed(_ section: Wheel.Section) { }
  func spinWheelDidFail(error: MoyaError) { }
}

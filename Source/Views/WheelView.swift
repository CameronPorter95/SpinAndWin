//
//  WheelView.swift
//  SpinAndWin
//

import Foundation
import SpriteKit

class WheelView: SKView {
  var wheelScene: WheelScene?
  var didBeginSpin: (Bool) -> Void = {_ in}
  var didEndSpin: () -> Void = {}
  var spinAndWinProvider: SpinAndWinProvider?
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  private func sharedInit() {
    wheelScene = WheelScene(fileNamed: "WheelScene")
    wheelScene?.scaleMode = .aspectFill
    presentScene(wheelScene)
  }
  
  func spin() {
    wheelScene?.spin()
  }
}

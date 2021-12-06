//
//  Wheel.swift
//  SpinAndWin
//

import SpriteKit

typealias Touch = (location: CGPoint, time: TimeInterval, angle: CGFloat, startingVector: CGVector, startingRotation: CGFloat) //Store current angle

class WheelScene: SKScene, SKPhysicsContactDelegate {
  
  var wheel: Wheel?
  let wheelCategory:UInt32 = 0b1
  let notchCategory:UInt32 = 0b1 << 1
  
  var touchInfo: Touch?

  override func didMove(to view: SKView) {
    wheel = self.childNode(withName: "Wheel") as? Wheel
    wheel?.texture = SKTextureAtlas(named: "Sprites").textureNamed("Wheel")
  }
  
  func spin() {
    guard let wheel = wheel,
    wheel.isSpinning == false,
    let wheelView = view as? WheelView else { return }
    wheel.physicsBody?.applyAngularImpulse(5)
    wheel.physicsBody?.angularDamping = 0.0
    wheel.isSpinning = true
    
    wheelView.spinAndWinProvider?.spinWheel()
    .onSuccess { (redemption: Redemption) in
      guard let section = redemption.prize?.category,
      let wheel = self.wheel else {
        return
      }
      wheel.angularVelocity = wheel.physicsBody?.angularVelocity ?? 5
      self.physicsWorld.speed = 0.0
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
        self?.wheel?.decelerate(toAngle: section.angle, rotations: Int(floor(wheel.angularVelocity / 2)))
      }
    }
    
    wheelView.didBeginSpin(true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    if let wheel = wheel,
    wheel.frame.contains(location) {
      let location = touch.location(in: self)
      let dx = location.x - wheel.position.x
      let dy = location.y - wheel.position.y
      let startingVector = CGVector(dx: dx, dy: dy)
      touchInfo = Touch(location, touch.timestamp, 0, startingVector, wheel.zRotation)
      wheel.isTouching = true
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first,
    let wheel = wheel,
    let touchInfo = touchInfo,
    !wheel.isSpinning else {
      return
    }
    
    wheel.physicsBody?.angularVelocity = 0.0
    wheel.removeAction(forKey: "decelerate")
    
    let location = touch.location(in: self)
    let dx = location.x - wheel.position.x
    let dy = location.y - wheel.position.y
    let vector = CGVector(dx: dx, dy: dy)
    var angle = vector.angle(from: touchInfo.startingVector)
    let touchIsLeft = vector.isLeft(of: touchInfo.startingVector)
    angle = touchIsLeft ? touchInfo.startingRotation + angle : touchInfo.startingRotation + ((2 * .pi) - angle)
    wheel.zRotation = angle
    
    let isClockwise = angle >= touchInfo.angle
    let deltaTime = CGFloat(touch.timestamp - touchInfo.time)
    let distance = CGVector(dx: location.x - touchInfo.location.x, dy: location.y - touchInfo.location.y).magnitude
    wheel.angularVelocity = (isClockwise ? 1 : -1) * (distance / deltaTime) / 60
    
    self.touchInfo = Touch(location, touch.timestamp, angle, touchInfo.startingVector, startingRotation: touchInfo.startingRotation)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    wheel?.isTouching = false
  }
  
  override func willMove(from view: SKView) {
    removeAllActions()
    removeAllChildren()
  }
  
  deinit {
    print("Deinit Wheel Scene")
  }
}

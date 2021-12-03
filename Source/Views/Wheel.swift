//
//  Wheel.swift
//  SpinAndWin
//

import SpriteKit

class Wheel: SKSpriteNode {
  var successSound = SKAction.playSoundFileNamed("TaDa.mp3", waitForCompletion: false)
  let limitAngularVelocity: (max: CGFloat, min: CGFloat) = (15, -15)
  
  var angularVelocity: CGFloat = 0.0 {
    didSet {
      angularVelocity = CGFloat.maximum(CGFloat.minimum(angularVelocity, limitAngularVelocity.max), limitAngularVelocity.min)
    }
  }
  
  var isSpinning = false {
    didSet {
      if !isSpinning {
        (scene?.view as? WheelView)?.didEndSpin()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
          guard let s = self else { return }
          s.run(s.successSound)
        }
      }
    }
  }
  
  var isTouching: Bool = false {
    didSet {
      if !isTouching && (angularVelocity > 0 || angularVelocity < 0) && !isSpinning {
        if angularVelocity > 5 || angularVelocity < -5 {
          physicsBody?.angularDamping = 0.0
          physicsBody?.angularVelocity = angularVelocity
          isSpinning = true
          
          ((self.scene as? WheelScene)?.view as? WheelView)?.spinAndWinProvider?.spinWheel()
          .onSuccess { (redemption: Redemption) in
            guard let section = redemption.prize?.category else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
              self?.scene?.physicsWorld.speed = 0.0
              self?.decelerate(toAngle: section.angle, rotations: Int(floor(self!.angularVelocity / 2)))
            }
          }
          
        } else {
          physicsBody?.angularDamping = 2.0
          physicsBody?.angularVelocity = angularVelocity
        }
        ((self.scene as? WheelScene)?.view as? WheelView)?.didBeginSpin(isSpinning)
      }
    }
  }
  
  func decelerate(toAngle: CGFloat, rotations: Int) {
    guard let physicsBody = physicsBody else { return }
    let isClockwise: Bool = angularVelocity < CGFloat(0.0) ? true : false
    let radius = CGFloat.squareRoot(physicsBody.area / CGFloat.pi)()
    let inertia = (physicsBody.mass * radius.squared) / 2
    let wi = angularVelocity // Initial Angular Velocity
    let wf: CGFloat = 0 // Final Angular Velocity
    let ti =  CGFloat.unitCircle(zRotation)  // Initial Theta
    var tf = CGFloat.unitCircle(toAngle) // Final Theta
    
    //Correction constant based on rate of rotation since there seems to be a delay between when the action is calcuated and when it is run
    //Without the correction the node stops a little off from its desired stop angle
    tf -= 0.00773889 * wi
    let extra = CGFloat(rotations) * 2 * CGFloat.pi
    var dt: CGFloat {
      if isClockwise {
        return tf > ti ? tf - ti - 2 * CGFloat.pi + extra : tf + extra - ti
      } else {
        return tf > ti ? tf + extra - ti : tf + 2 * CGFloat.pi + extra - ti
      }
    }
    
    let a = (isClockwise ? 1 : -1) * 0.5 * wi.squared / abs(dt) // Angular Acceleration
    let time: Double = Double(abs((wf - wi) / a)) // Time needed to stop
    let torque: CGFloat = inertia * a // Torque needed to stop
    
    scene?.physicsWorld.speed = 1.0
    run(SKAction.applyTorque(torque, duration: time), withKey: "decelerate") { [weak self] in
      guard let s = self else { return }
      s.run(SKAction.rotate(toAngle: toAngle, duration: 0.5, shortestUnitArc: true)) { [weak self] in
        self?.isSpinning = false
      }
    }
    angularVelocity = 0.0
  }
  
  enum Section: String, CaseIterable, Codable {
    case oneFreeTransfer = "a free transfer"
    case twoFreeTransfer = "2 free transfers"
    case threeFreeTransfer = "3 free transfers"
    case fourFreeTransfer = "4 free transfers"
    case fiveFreeTransfer = "5 free transfers"
    case twoHundredOff = "up to $200 off your transfer"
    case scooter = "a scooter"
    
    var maxAngle: [CGFloat] {
      switch self {
      case .oneFreeTransfer:
        return [(2 * .pi) / 16, (6 * .pi) / 16, (14 * .pi) / 16, (22 * .pi) / 16, (28 * .pi) / 16]
      case .twoFreeTransfer:
        return [(18 * .pi) / 16, (26 * .pi) / 16]
      case .threeFreeTransfer:
        return [(10 * .pi) / 16, (30 * .pi) / 16]
      case .fourFreeTransfer:
        return [(4 * .pi) / 16, (12 * .pi) / 16]
      case .fiveFreeTransfer:
        return [(20 * .pi) / 16, (24 * .pi) / 16]
      case .twoHundredOff:
        return [(8 * .pi) / 16, (16 * .pi) / 16]
      case .scooter:
        return [(32 * .pi) / 16]
      }
    }
    
    var angle: CGFloat {
      return maxAngle.randomElement()!// - ((2 * .pi) / 32)
    }
    
    var image: UIImage {
      switch self {
      case .oneFreeTransfer:
        return #imageLiteral(resourceName: "FreeTransfers")
      case .twoFreeTransfer:
        return #imageLiteral(resourceName: "FreeTransfers")
      case .threeFreeTransfer:
        return #imageLiteral(resourceName: "FreeTransfers")
      case .fourFreeTransfer:
        return #imageLiteral(resourceName: "FreeTransfers")
      case .fiveFreeTransfer:
        return #imageLiteral(resourceName: "FreeTransfers")
      case .twoHundredOff:
        return #imageLiteral(resourceName: "MoneyBack")
      case .scooter:
        return #imageLiteral(resourceName: "Scooter")
      }
    }
  }
}

extension Wheel.Section {
  static var count: CGFloat {
    return CGFloat(Wheel.Section.allCases.count)
  }
}

extension CGFloat {
  var squared: CGFloat { return self * self }
  
  static func unitCircle(_ value: CGFloat) -> CGFloat {
    return value < 0 ? 2 * CGFloat.pi + value : value
  }
}

extension SKNode {
  func run(_ action: SKAction, withKey key: String, completion: @escaping () -> Void) {
    let completionAction = SKAction.run(completion)
    let compositeAction = SKAction.sequence([action, completionAction])
    run(compositeAction, withKey: key)
  }
}

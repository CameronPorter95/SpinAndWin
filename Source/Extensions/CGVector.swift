//
//  CGVector.swift
//  SpinAndWin
//
//  Created by Cam on 3/12/21.
//

import Foundation
import SpriteKit

extension CGVector {
  var magnitude: CGFloat {
    return ((self.dx * self.dx) + (self.dy * self.dy)).squareRoot()
  }
  
  var unitVector: CGVector {
    return CGVector(dx: dx/magnitude, dy: dy/magnitude)
  }
  
  func dotProduct(with vector: CGVector) -> CGFloat {
    return CGFloat(dot(float2(x: Float(dx), y: Float(dy)), float2(x: Float(vector.dx), y: Float(vector.dy))))
  }
  
  func angle(from vector: CGVector) -> CGFloat {
    return acos(dotProduct(with: vector) / (magnitude * vector.magnitude))
  }
  
  func normal(leftSide: Bool) -> CGVector {
    return CGVector(dx: leftSide ? dy : -dy, dy: leftSide ? -dx : dx)
  }
  
  func isLeft(of vector: CGVector) -> Bool {
    return dotProduct(with: vector.normal(leftSide: true)) > 0 ? false : true
  }
}

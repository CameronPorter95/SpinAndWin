//
//  UIView.swift
//  SpinAndWin
//
//  Created by Cam on 3/12/21.
//

import UIKit

extension UIView {
  @IBInspectable var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    set {
      guard let uiColor = newValue else { return }
      layer.borderColor = uiColor.cgColor
    }
    get {
      guard let color = layer.borderColor else { return nil }
      return UIColor(cgColor: color)
    }
  }
  
  @IBInspectable var shadowColor: UIColor? {
    set {
      guard let uiColor = newValue else { return }
      layer.shadowColor = uiColor.cgColor
    }
    get{
      guard let color = layer.shadowColor else { return nil }
      return UIColor(cgColor: color)
    }
  }
  
  @IBInspectable var shadowOpacity: Float {
    set {
      layer.shadowOpacity = newValue
    }
    get{
      return layer.shadowOpacity
    }
  }
  
  @IBInspectable var shadowOffset: CGSize {
    set {
      layer.shadowOffset = newValue
    }
    get{
      return layer.shadowOffset
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    set {
      layer.shadowRadius = newValue
    }
    get{
      return layer.shadowRadius
    }
  }
}

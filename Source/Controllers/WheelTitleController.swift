//
//  WheelTitleController.swift
//  SpinAndWin
//

import SpriteKit
import Macaw
import UIKit
import DynamicColor

class WheelTitleController: ProviderController {
  @IBOutlet weak var logo: SVGView!
  @IBOutlet weak var wheelLights: SVGView!
  @IBOutlet weak var wheelSections: SVGView!
  @IBOutlet weak var ticker: SVGView!
  @IBOutlet weak var wheelCentre: SVGView!
  @IBOutlet weak var submitButton: UIButton!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    backendProvider = BackendProvider.instance()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    clearSVGs([logo, wheelLights, wheelSections, ticker, wheelCentre])
    
    let gradient = CAGradientLayer()
    gradient.frame = view.frame
    gradient.colors = [UIColor(hexString: "00b5cc").cgColor, UIColor.white.cgColor]
    view.layer.insertSublayer(gradient, at: 0)
    
    SKTextureAtlas(named: "Sprites").preload(completionHandler: {})
  }
  
  override func viewDidAppear(_ animated: Bool) {
    animateWheel()
  }
  
  func animateWheel() {
    UIView.animate(withDuration: 0.75, delay: 0.5, options: .curveEaseInOut, animations: {
      self.wheelSections.transform = CGAffineTransform(rotationAngle: .pi / 35)
    }, completion: { _ in
      
      UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
        self.wheelSections.transform = CGAffineTransform(rotationAngle: .pi / -35)
      }, completion: { _ in
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
          self.wheelSections.transform = CGAffineTransform(rotationAngle: 0)
        })
      })
    })
  }
  
  func clearSVGs(_ svgs: [SVGView]) {
    _ = svgs.map {
      $0.layer.masksToBounds = false
      $0.backgroundColor = .clear
    }
  }
  
  @objc func backPressed() {
//    performSegue(withIdentifier: R.segue.wheelTitleController.unwindToConfirmation, sender: self)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    submitButton.shadowOpacity = 0.25
  }
  
  @IBAction func submitPressedDown(_ sender: UIButton) {
    sender.shadowOpacity = 0.0
  }
  
  @IBAction func submitTouchCancelled(_ sender: UIButton) {
    sender.shadowOpacity = 0.25
  }
  
  @IBAction func unwindToWheelTitle(segue: UIStoryboardSegue) {
  }
}


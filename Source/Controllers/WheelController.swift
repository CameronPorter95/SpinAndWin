//
//  WheelController.swift
//  SpinAndWin
//
//  Created by OrbitRemit LAP048 on 18/11/19.
//

import UIKit
import Moya
import Macaw
import DynamicColor

class WheelController: ProviderController {
  @IBOutlet var wheelView: WheelView!
  @IBOutlet var congratulationsView: UIView!
  @IBOutlet weak var prizeView: UIView!
  @IBOutlet weak var congratulationsCurve: UIView!
  @IBOutlet weak var prizeLabel: UILabel!
  @IBOutlet var shareView: UIView!
  @IBOutlet weak var shareCurve: UIView!
  @IBOutlet weak var shareStack: UIStackView!
  @IBOutlet weak var invalidSpinLabel: UILabel!
  @IBOutlet weak var prize: UIImageView!
  @IBOutlet weak var lights: SVGView!
  @IBOutlet weak var lights2: SVGView!
  @IBOutlet weak var centre: SVGView!
  @IBOutlet weak var ticker: SVGView!
  @IBOutlet weak var congratulations: SVGView!
  
  var isSpinning = false
  var congratulationBottomConstraint: NSLayoutConstraint!
  var shareTopConstraint: NSLayoutConstraint!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
//    applyNavigationBarStyle(tintColor: .white, textColor: .white)
    navigationItem.hidesBackButton = false
    clearSVGs([lights, lights2, centre, ticker, congratulations])
    let baseGradient = CAGradientLayer()
    baseGradient.frame = view.frame
    baseGradient.colors = [UIColor(hexString: "00b5cc").cgColor, UIColor.white.cgColor]
    view.layer.insertSublayer(baseGradient, at: 0)
    wheelView.spinAndWinProvider = backendProvider?.spinAndWinProvider
    backendProvider?.spinAndWinProvider.addToDelegates(self)
    setupPrizeScreen()
    
    wheelView.didBeginSpin = { [weak self] isValid in
      guard isValid else {
        self?.invalidSpinLabel.isHidden = isValid
        return
      }
      self?.isSpinning = true
      self?.flashLights()
      self?.navigationItem.hidesBackButton = true
    }
    
    wheelView.didEndSpin = { [weak self] in
      self?.isSpinning = false
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
        var loop: ((Int) -> Void)!
        loop = { [weak self] count in
          guard let s = self else { return }
          guard count > 0 else {
            s.animateSuccess()
            return
          }
          s.lights.isHidden = s.lights2.isHidden
          s.lights2.isHidden = !s.lights2.isHidden
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            loop(count - 1)
          }
        }
        loop(7)
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    let prizeGradient = CAGradientLayer()
    prizeGradient.frame = CGRect(origin: .zero, size: congratulationsCurve.bounds.size)
    prizeGradient.colors = [UIColor(hexString: "00b5cc").cgColor, UIColor(hexString: "98D9E4").cgColor]
    
    _ = congratulationsCurve.layer.sublayers?.map { $0.removeFromSuperlayer() }
    congratulationsCurve.layer.insertSublayer(prizeGradient, at: 0)
    congratulationsCurve.layer.cornerRadius = congratulationsCurve.frame.width / 2
    shareCurve.layer.cornerRadius = shareCurve.frame.width / 2
    prizeView.layer.cornerRadius = prizeView.frame.width / 2
  }
  
  func setupPrizeScreen() {
    view.addSubview(shareView)
    view.addSubview(congratulationsView)
    congratulationsView.translatesAutoresizingMaskIntoConstraints = false
    shareView.translatesAutoresizingMaskIntoConstraints = false
    
    congratulationsView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    congratulationsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    congratulationsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.72).isActive = true
    congratulationBottomConstraint = congratulationsView.bottomAnchor.constraint(equalTo: view.topAnchor)
    shareView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    shareView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    shareView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
    shareTopConstraint = shareView.topAnchor.constraint(equalTo: view.bottomAnchor)
    congratulationBottomConstraint?.isActive = true
    shareTopConstraint?.isActive = true
    
    shareCurve.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.65).isActive = true
    congratulationsCurve.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.65).isActive = true
    
    congratulationsView.clipsToBounds = true
    congratulationsCurve.layer.masksToBounds = true
    congratulationsCurve.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    shareView.clipsToBounds = true
    shareCurve.layer.masksToBounds = true
    shareCurve.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    congratulationsView.shadowColor = .black
    congratulationsView.shadowOpacity = 0.25
    congratulationsView.shadowOffset = CGSize(width: 0, height: 7)
  }
  
  func animateSuccess() {
    shareStack.alpha = 0
    congratulationBottomConstraint.isActive = false
    shareTopConstraint.isActive = false
    congratulationsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    shareView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
      self.view.layoutIfNeeded()
      self.navigationItem.hidesBackButton = true
    }, completion: { _ in
      UIView.animate(withDuration: 0.5, animations: {
        self.shareStack.alpha = 1
      })
    })
  }
  
  func flashLights() {
    guard isSpinning else { return }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
      guard let s = self else { return }
      s.lights.isHidden = s.lights2.isHidden
      s.lights2.isHidden = !s.lights2.isHidden
      s.flashLights()
    }
  }
  
  func clearSVGs(_ svgs: [SVGView]) {
    _ = svgs.map {
      $0.layer.masksToBounds = false
      $0.backgroundColor = .clear
    }
  }
  
  @IBAction func spinPressed(sender: UIButton) {
    wheelView.spin()
    sender.shadowOpacity = 0.25
  }
  
  @IBAction func sharePressed(_ sender: UIButton) {
    sender.shadowOpacity = 0.25
    var shareContent = ""
    if var section = backendProvider?.spinAndWinProvider.section?.rawValue {
      section = section == Wheel.Section.twoHundredOff.rawValue ? "cash back" : section
      shareContent = "I’ve just won \(section) by using OrbitRemit to send money from Australia to the Philippines. Give it a go!"
    }
    let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.mail]
    if UIDevice.current.userInterfaceIdiom == .pad {
      activityViewController.popoverPresentationController?.sourceView = shareStack
    }
    present(activityViewController, animated: true, completion: {})
  }
  
  @IBAction func buttonPressed(_ sender: UIButton) {
    sender.shadowOpacity = 0.0
  }
  
  @IBAction func touchCancelled(_ sender: UIButton) {
    sender.shadowOpacity = 0.25
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
    if motion == .motionShake {
      wheelView.spin()
    }
  }
}

extension WheelController: SpinAndWinDelegate {
  func spinWheelDidSucceed(_ section: Wheel.Section) {
    prizeLabel.text = "\(section.rawValue)".capitalized
    prize.image = section.image
  }
  
  func spinWheelDidFail(error: MoyaError) {
//    let a = [AlertAction(title: "Retry".localized, isBlockable: false, handler: {
//      self.performSegue(withIdentifier: R.segue.wheelController.unwindToWheelTitle, sender: nil)
//    }),
//    AlertAction(title: "Skip".localized, isBlockable: false, handler: {
//      self.performSegue(withIdentifier: R.segue.wheelController.unwindToConfirmation, sender: error)
//    })]
    
//    withAlert(actions: a) { throw error }
  }
}

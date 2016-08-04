//
//  ViewController.swift
//  uiviewpropertyanimator
//
//  Created by JARMourato on 03/08/16.
//  Copyright © 2016 swiftification. All rights reserved.
//

import UIKit

let squareSize: CGFloat = 100

final class InteractingViewController: UIViewController {
  
  @IBOutlet var redView: UIView!
  @IBOutlet var durationStepper: UIStepper!
  @IBOutlet var pauseButton: UIButton!
  @IBOutlet var startStopButton: UIButton!
  @IBOutlet var restartButton: UIButton!
  @IBOutlet var durationLabel: UILabel!
  @IBOutlet var reverseAnimationSwitch: UISwitch!
  
  private var duration: TimeInterval {
    let durationStepperVal = durationStepper.value
    return TimeInterval(durationStepperVal)
  }
  
  let redStartFrame: CGRect = CGRect(x: 16, y: 45, width: squareSize, height: squareSize)

  var redAnimator: UIViewPropertyAnimator?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    pauseButton.isEnabled = false
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupAnimators()
  }

  func setupAnimators() {
    redAnimator = move(view: redView, startFrame: redStartFrame)
    redAnimator?.addCompletion({ (position) in
      self.startStopButton.setTitle("Start", for: .normal)
      self.startStopButton.isEnabled = false
      self.pauseButton.isEnabled = false
      self.restartButton.isEnabled = true
    })
  }
  
  @IBAction func stepperValueChanged(_ sender: AnyObject) {
    durationLabel.text = "\(durationStepper.value)"
  }
  
  @IBAction func reverseAnimatorSwitchValueChanged(_ sender: UISwitch) {
    guard let redAnimator = redAnimator,
      redAnimator.isRunning
      else { return }
    
    redAnimator.isReversed = sender.isOn
  }
  
}

extension InteractingViewController {
  
  func move(view: UIView, startFrame: CGRect) -> UIViewPropertyAnimator {
    view.frame = startFrame
    let margin: CGFloat = 16
    let screenWidth: CGFloat = self.view.bounds.width
    let finalX: CGFloat = screenWidth - squareSize - margin
    let finalFrame = CGRect(x: finalX, y: startFrame.origin.y, width: squareSize, height: squareSize)
    print("startFrame \(startFrame) - endFrame \(finalFrame)")
    return UIViewPropertyAnimator(duration: duration, curve: .linear) {
      view.frame = finalFrame
    }
  }
}

extension InteractingViewController {
  
  @IBAction func restartAnimations(_ sender: UIButton) {
    setupAnimators()
    startStopButton.isEnabled = true
    self.reverseAnimationSwitch.isOn = false
  }
  
  @IBAction func startStopPause(_ sender: UIButton) {
    restartButton.isEnabled = false
    guard let redAnimator = redAnimator else { return }
    guard sender != pauseButton else {
      let title: String = redAnimator.isRunning ? "Unpause" : "Pause"
      redAnimator.isRunning ? redAnimator.pauseAnimation() : redAnimator.startAnimation()
      startStopButton.isEnabled = redAnimator.isRunning
      pauseButton.setTitle(title, for: .normal)
      return
    }
    switch redAnimator.state {
    case .inactive:
      redAnimator.startAnimation()
      startStopButton.setTitle("Stop", for: .normal)
      pauseButton.isEnabled = true
      print("inactive")
    case .active:
      if redAnimator.isRunning {
        redAnimator.stopAnimation(false)
        redAnimator.finishAnimation(at: .current)
        startStopButton.setTitle("Start", for: .normal)
        pauseButton.isEnabled = false
      } else { // was paused or scrubed
        redAnimator.startAnimation()
        startStopButton.setTitle("Stop", for: .normal)
        pauseButton.isEnabled = true
      }
      print("active")
    case .stopped:
      print("stopped")
      break
    }
  }
  
  @IBAction func scrubAnimation(_ sender: UISlider) {
    guard let redAnimator = redAnimator else { return }
    if redAnimator.isRunning {
      redAnimator.pauseAnimation()
    }
    redAnimator.fractionComplete = CGFloat(sender.value)
  }
}

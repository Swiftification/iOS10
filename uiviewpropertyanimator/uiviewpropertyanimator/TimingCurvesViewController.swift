//
//  TimingCurvesViewController.swift
//  uiviewpropertyanimator
//
//  Created by JARMourato on 04/08/16.
//  Copyright © 2016 swiftification. All rights reserved.
//

import UIKit

let miniSquareSize: CGFloat = 50


final class TimingCurvesViewController: UIViewController {
  
  @IBOutlet var redView: UIView!
  @IBOutlet var blueView: UIView!
  @IBOutlet var greenView: UIView!
  @IBOutlet var yellowView: UIView!
  
  let redStartFrame: CGRect = CGRect(x: 16, y: 50, width: miniSquareSize, height: miniSquareSize)
  var redAnimator: UIViewPropertyAnimator?
  
  let blueStartFrame: CGRect = CGRect(x: 16, y: 120, width: miniSquareSize, height: miniSquareSize)
  var blueAnimator: UIViewPropertyAnimator?

  let greenStartFrame: CGRect = CGRect(x: 16, y: 190, width: miniSquareSize, height: miniSquareSize)
  var greenAnimator: UIViewPropertyAnimator?

  let yellowStartFrame: CGRect = CGRect(x: 16, y: 260, width: miniSquareSize, height: miniSquareSize)
  var yellowAnimator: UIViewPropertyAnimator?

  let durationOfAnimation: TimeInterval = 1.5

  var timer: Timer?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    timer = Timer.scheduledTimer(withTimeInterval: durationOfAnimation*1.5, repeats: true, block: runAppleCurvesExample)
  }
  
  func runAppleCurvesExample(timer: Timer) {
    //startAnimationsWith(appleDefaultCurves)
//    startAnimationsWith(cubicCurves)
//    startAnimationsWith(springCurves)
    startAnimationsWith(springCustomCurves)
  }
  
  
  func startAnimationsWith(_ animatorInitBlock: () -> ()) {
    animatorInitBlock()
    redAnimator?.startAnimation()
    blueAnimator?.startAnimation()
    greenAnimator?.startAnimation()
    yellowAnimator?.startAnimation()
  }
  
  func appleDefaultCurves() {
    redAnimator = animatorFor(view: redView, startFrame: redStartFrame, curve: .linear)
    blueAnimator = animatorFor(view: blueView, startFrame: blueStartFrame, curve: .easeIn)
    greenAnimator = animatorFor(view: greenView, startFrame: greenStartFrame, curve: .easeInOut)
    yellowAnimator = animatorFor(view: yellowView, startFrame: yellowStartFrame, curve: .easeOut)
  }
  
  func cubicCurves() {
    let redCubicParameters: UITimingCurveProvider = UICubicTimingParameters(animationCurve: .easeInOut)
    let c1 = CGPoint(x: 0.7, y: 0.0)
    let c2 = CGPoint(x: 0.3, y: 1.0)
    let blueCubicParameters: UITimingCurveProvider = UICubicTimingParameters(controlPoint1: c1, controlPoint2: c2)
    redAnimator = animatorFor(view: redView, startFrame: redStartFrame, timingParameters: redCubicParameters)
    blueAnimator = animatorFor(view: blueView, startFrame: blueStartFrame, timingParameters: blueCubicParameters)
  }
  
  func springCurves() {
    let underDamped: CGFloat = 0.5
    let criticallyDamped: CGFloat = 1.0
    let overDamped: CGFloat = 2.0
    redAnimator = animatorFor(view: redView, startFrame: redStartFrame, dampingRatio: underDamped)
    blueAnimator = animatorFor(view: blueView, startFrame: blueStartFrame, dampingRatio: criticallyDamped)
    greenAnimator = animatorFor(view: greenView, startFrame: greenStartFrame, dampingRatio: overDamped)
  }
  
  func springCustomCurves() {
    let mass: CGFloat = 2.0
    let stiffness: CGFloat = 25.0
    let damping: CGFloat = 2*sqrt(mass*stiffness)
    let underDamped: CGFloat = 0.5 * damping
    let springParameters: UISpringTimingParameters = UISpringTimingParameters(mass: mass, stiffness: stiffness, damping: underDamped, initialVelocity: CGVector.zero)
    let dampingRatio: CGFloat = 0.5
    redAnimator = animatorFor(view: redView, startFrame: redStartFrame, dampingRatio: dampingRatio)
    blueAnimator = animatorFor(view: blueView, startFrame: blueStartFrame, timingParameters: springParameters)
  }
  
  private func animatorFor(view: UIView, startFrame: CGRect, curve: UIViewAnimationCurve) -> UIViewPropertyAnimator {
    view.frame = startFrame
    let margin: CGFloat = 16
    let screenWidth: CGFloat = self.view.bounds.width
    let finalX: CGFloat = screenWidth - miniSquareSize - margin
    let finalFrame = CGRect(x: finalX, y: startFrame.origin.y, width: miniSquareSize, height: miniSquareSize)
    return UIViewPropertyAnimator(duration: durationOfAnimation, curve: curve) {
      view.frame = finalFrame
    }
  }
  
  private func animatorFor(view: UIView, startFrame: CGRect, timingParameters: UITimingCurveProvider) -> UIViewPropertyAnimator {
    view.frame = startFrame
    let margin: CGFloat = 16
    let screenWidth: CGFloat = self.view.bounds.width
    let finalX: CGFloat = screenWidth - miniSquareSize - margin
    let finalFrame = CGRect(x: finalX, y: startFrame.origin.y, width: miniSquareSize, height: miniSquareSize)
    let animator = UIViewPropertyAnimator(duration: durationOfAnimation, timingParameters: timingParameters)
    animator.addAnimations {
      view.frame = finalFrame
    }
    return animator
  }
  
  private func animatorFor(view: UIView, startFrame: CGRect, dampingRatio: CGFloat) -> UIViewPropertyAnimator {
    view.frame = startFrame
    let margin: CGFloat = 16
    let screenWidth: CGFloat = self.view.bounds.width
    let finalX: CGFloat = screenWidth - miniSquareSize - margin
    let finalFrame = CGRect(x: finalX, y: startFrame.origin.y, width: miniSquareSize, height: miniSquareSize)
    return UIViewPropertyAnimator(duration: durationOfAnimation, dampingRatio: dampingRatio) {
      view.frame = finalFrame
    }
  }
  
}

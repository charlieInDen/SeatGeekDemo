//
//  SlideInPresentationAnimator.swift
//  SeatGeekDemo
//
//  Created by Nishant Sharma on 21/04/2019
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

class SlideInPresentationAnimator: NSObject {
  // MARK: - Properties
  let direction: PresentationDirection

  let isPresentation: Bool

  //3
  // MARK: - Initializers
  init(direction: PresentationDirection, isPresentation: Bool) {
    self.direction = direction
    self.isPresentation = isPresentation
    super.init()
  }
}

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let key = isPresentation ? UITransitionContextViewControllerKey.to
      : UITransitionContextViewControllerKey.from

    let controller = transitionContext.viewController(forKey: key)!

    if isPresentation {
      transitionContext.containerView.addSubview(controller.view)
    }

    let presentedFrame = transitionContext.finalFrame(for: controller)
    var dismissedFrame = presentedFrame

    switch direction {
    case .left(.overlay):
      dismissedFrame.origin.x = -presentedFrame.width
    case .left(.reveal):
      break
    case .left(.ssa):
      break
    case .right:
      dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
    case .top:
      dismissedFrame.origin.y = -presentedFrame.height
    case .bottom:
      dismissedFrame.origin.y = transitionContext.containerView.frame.size.height

    }

    let initialFrame = isPresentation ? dismissedFrame : presentedFrame
    let finalFrame = isPresentation ? presentedFrame : dismissedFrame
    var animationDuration: Double  =  0.0

//    if isPresentation {
     animationDuration = transitionDuration(using: transitionContext)
//    }

    controller.view.frame = initialFrame
    UIView.animate(withDuration: animationDuration, animations: {
      controller.view.frame = finalFrame
    }) { finished in
      transitionContext.completeTransition(finished)
    }
  }
}

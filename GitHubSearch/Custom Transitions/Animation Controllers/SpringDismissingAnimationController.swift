import UIKit

class SpringDismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
    
    fromVC.view.transform = CGAffineTransform.identity
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
          fromVC.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }
    },
      completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
//  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//    guard
//      let fromVC = transitionContext.viewController(forKey: .from),
//      let toVC = transitionContext.viewController(forKey: .to)
//    else {
//      return
//    }
//
//    toVC.view.tintAdjustmentMode = .normal
//    toVC.view.isUserInteractionEnabled = true
//
//    fromVC.view.transform = CGAffineTransform.identity
//    let duration = transitionDuration(using: transitionContext)
//
//    UIView.animateKeyframes(
//      withDuration: duration,
//      delay: 0,
//      options: .calculationModeCubic,
//      animations: {
//        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
//          fromVC.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
//        }
//    },
//      completion: { _ in
//        fromVC.view.removeFromSuperview()
//        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    })
//  }
  
}

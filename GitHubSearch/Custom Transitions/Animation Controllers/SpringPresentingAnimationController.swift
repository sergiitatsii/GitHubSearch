import UIKit

class SpringPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 2.0
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toVC = transitionContext.viewController(forKey: .to) else { return }
    
    let containerView = transitionContext.containerView
    containerView.addSubview(toVC.view)
    
    toVC.view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0,
      options: .calculationModeCubic,
      animations: {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
          toVC.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
          toVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
          toVC.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
          toVC.view.transform = CGAffineTransform.identity
        }
    },
      completion: { _ in
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
  
//  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//    guard
//      let fromVC = transitionContext.viewController(forKey: .from),
//      let toVC = transitionContext.viewController(forKey: .to),
//      let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
//    else {
//      return
//    }
//
//    fromVC.view.tintAdjustmentMode = .dimmed
//    fromVC.view.isUserInteractionEnabled = false
//
//    let containerView = transitionContext.containerView
//
//    containerView.addSubview(toVC.view)
//    containerView.addSubview(snapshot)
//    toVC.view.isHidden = true
//
//    snapshot.layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)
//    let duration = transitionDuration(using: transitionContext)
//
//    UIView.animateKeyframes(
//      withDuration: duration,
//      delay: 0,
//      options: .calculationModeCubic,
//      animations: {
//        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
//          snapshot.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
//        }
//
//        UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
//          snapshot.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0)
//        }
//
//        UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
//          snapshot.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
//        }
//
//        UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
//          snapshot.layer.transform = CATransform3DIdentity
//        }
//    },
//      completion: { _ in
//        toVC.view.isHidden = false
//        snapshot.removeFromSuperview()
//        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//    })
//  }
  
}

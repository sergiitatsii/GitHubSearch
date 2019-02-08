import UIKit

extension UIStoryboard {
  /// Utility constructor
  public convenience init(_ name: String, bundle: Bundle? = Bundle.main) {
    self.init(name: name, bundle: bundle)
  }
  
  /// Instantiate initial controller or by controller class name. If instantiated controller is UINavigationController - tries to take it first controller
  ///
  /// - parameter type: required controller type
  /// - parameter initial: if true - instantiates initial viewController, if no - controller with String(self) identifier
  /// - returns: controller instance if everything is ok
  public func instantiateViewController<T: UIViewController>(_ type: T.Type, initial: Bool = false) -> T? {
    let controller = initial ? instantiateInitialViewController() : self.instantiateViewController(withIdentifier: String(describing: T.self))
    if controller is T {
      return controller as? T
    }
    if let navigation = controller as? UINavigationController {
      let first = navigation.viewControllers.first as? T
      first?.removeFromParent()
      return first
    }
    return nil
  }
  
}

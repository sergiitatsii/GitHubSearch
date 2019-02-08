import UIKit

extension UIView {
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable var borderColor : UIColor {
    get {
      return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
    }
    set {
      layer.borderColor = newValue.cgColor
    }
  }
  
  @IBInspectable var patternColorImage: String {
    get {
      return ""
    }
    set {
      backgroundColor = UIColor(patternImage: UIImage(named: newValue) ?? UIImage())
    }
  }
  
  /// Signature using box-shadow in Avocode:
  /// box-shadow 0 1px 6px rgba(0,0,0,0.1)
  /// 0 1 - shadowOffset
  /// 6px - shadowRadius - should be divided by 2
  /// 0.1 - shadowOpacity
  func applyShadow(_ offset: CGSize = CGSize(width: 0, height: 1), radius: CGFloat = 3, opacity: Float = 0.1) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    layer.shadowOffset = offset
  }
  
}

extension UIView {
  
  /// Loads view from xib with `xibName` in bundle for current class.
  static func loadFromXibNamed(_ xibName : String) -> UIView? {
    guard let topLevelObjects = Bundle(for: self).loadNibNamed(xibName, owner: nil, options: nil) else {
      return nil
    }
    
    for object in topLevelObjects.compactMap( { $0 as AnyObject }) {
      if object.isKind(of: self) {
        return object as? UIView
      }
    }
    return nil
  }
  
  /// Loads view from xib with `String(describing:self)` name in bundle for current class.
  static func loadFromXib() -> UIView? {
    return self.loadFromXibNamed(String(describing: self))
  }
  
}

import UIKit

extension UIColor {
  
  enum GitHubSearch {
    static var red: UIColor { return UIColor(hex: "#DA5D3F") }
    static var green: UIColor { return UIColor(hex: "#56BC8A") }
    static var blue: UIColor { return UIColor(red: 82, green: 159, blue: 205) }
    static var lightGray: UIColor { return UIColor(red: 249, green: 250, blue: 251) }
  }
  
}

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(red)/255
    let newGreen = CGFloat(green)/255
    let newBlue = CGFloat(blue)/255
    
    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }
  
  convenience init(hex: String, alpha: CGFloat = 1) {
    assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
    
    let scanner = Scanner(string: hex)
    scanner.scanLocation = 1  // skip #
    
    var rgb: UInt32 = 0
    scanner.scanHexInt32(&rgb)
    
    self.init(
      red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
      green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
      blue:  CGFloat((rgb &     0xFF)      )/255.0,
      alpha: alpha)
  }
  
}

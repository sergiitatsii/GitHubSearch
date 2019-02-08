import UIKit

protocol Reusable {
  static var reuseID: String { get }
}

extension Reusable {
  static var reuseID: String {
    return String(describing: self)
  }
}

extension UITableViewCell: Reusable { }

extension UITableView {
  
  func register<T: UITableViewCell>(cellClass: T.Type = T.self) {
    let bundle = Bundle(for: cellClass.self)
    if bundle.path(forResource: cellClass.reuseID, ofType: "nib") != nil {
      let nib = UINib(nibName: cellClass.reuseID, bundle: bundle)
      register(nib, forCellReuseIdentifier: cellClass.reuseID)
    } else {
      register(cellClass.self, forCellReuseIdentifier: cellClass.reuseID)
    }
  }
  
}

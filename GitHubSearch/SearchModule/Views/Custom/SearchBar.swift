import UIKit

public class SearchBar: UISearchBar, UISearchBarDelegate {
  
  /// Throttle engine
  private var throttler: Throttler? = nil
  
  /// Throttling interval
  public var throttlingInterval: Double? = 0 {
    didSet {
      guard let interval = throttlingInterval else {
        throttler = nil
        return
      }
      throttler = Throttler(timeInterval: interval)
    }
  }
  
  /// Event received when cancel is pressed
  public var onCancel: (() -> (Void))? = nil
  
  /// Event received when a change into the search box is occurred
  public var onSearch: ((String) -> (Void))? = nil
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public init() {
    super.init(frame: CGRect.zero)
    delegate = self
  }
  
  // MARK: - UISearchBarDelegate
  public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.onCancel?()
  }
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //self.onSearch?(text ?? "")
  }
  
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let throttler = throttler else {
      onSearch?(searchText)
      return
    }
    throttler.throttle {
      DispatchQueue.main.async {
        self.onSearch?(self.text ?? "")
      }
    }
  }
  
}

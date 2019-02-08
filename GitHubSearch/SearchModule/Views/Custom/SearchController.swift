import UIKit

public class SearchController: UISearchController {
  
  var throttledSearchBar = SearchBar()
  
  override public var searchBar: UISearchBar {
    get {
      return throttledSearchBar
    }
  }
  
}

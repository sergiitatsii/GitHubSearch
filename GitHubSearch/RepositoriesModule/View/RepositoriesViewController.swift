import UIKit

class RepositoriesViewController: UITabBarController {
  
  var presenter: RepositoriesPresenterInterface?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.viewWillAppear()
  }
  
}

// MARK: - RepositoriesViewInterface
extension RepositoriesViewController: RepositoriesViewInterface {
  
  func observeReachability() {
    ReachabilityService.shared.whenReachable = { reachability in
      
    }
    
    ReachabilityService.shared.whenUnreachable = { [unowned self] reachability in
      if self.selectedIndex == Tab.search.rawValue {
        self.selectedIndex = Tab.recents.rawValue
      }
    }
  }
  
}

// MARK: - UITabBarControllerDelegate
extension RepositoriesViewController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    guard
      let navigationVC = viewController as? UINavigationController,
      let _ = navigationVC.topViewController as? SearchRepositoriesViewController
    else {
      return true
    }
    
    if !ReachabilityService.shared.isConnected {
      //presenter?.router?.presentPopup(title: "Sorry", message: "Search is not available in offline mode.")
      presenter?.router?.presentSettingsPopup()
      return false
    }
    
    if !SessionManager.shared.isAuthorized {
      presenter?.router?.presentLoginPopup()
      return false
    }
    
    return true
  }
  
}

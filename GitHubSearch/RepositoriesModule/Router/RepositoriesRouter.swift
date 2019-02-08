import UIKit

enum Tab: Int {
  case search
  case recents
}

class RepositoriesRouter: RepositoriesRouterInterface {
  
  weak var presenter: RepositoriesPresenterInterface?
  weak var tabBarController: UITabBarController?
  var repositoryDetailTransitioningDelegate: RepositoryDetailTransitioningDelegate?
  
  static func createModule() -> UIViewController {
    // Create layers
    let router = RepositoriesRouter()
    router.repositoryDetailTransitioningDelegate = RepositoryDetailTransitioningDelegate()
    let searchRepositoriesVC = SearchRepositoriesRouter.createModule(with: router)
    let recentRepositoriesVC = RecentRepositoriesRouter.createModule(with: router)
    let viewControllers = [searchRepositoriesVC, recentRepositoriesVC]
    let view = RepositoriesViewController()
    view.setViewControllers(viewControllers, animated: true)
    view.selectedIndex = Tab.search.rawValue
    
    if !SessionManager.shared.isAuthorized || !ReachabilityService.shared.isConnected {
      view.selectedIndex = Tab.recents.rawValue
    }
    
    let presenter = RepositoriesPresenter()
    
    // Connect layers
    view.presenter = presenter
    presenter.view = view
    presenter.router = router
    router.presenter = presenter
    router.tabBarController = view
    
    return view
  }
  
  func presentPopup(title: String?, message: String?) {
    guard let selectedViewController = tabBarController?.selectedViewController else { return }
    AlertView.show(title: title, message: message, in: selectedViewController)
  }
  
  func presentRepositoryDetailScreen(for repository: Repository) {
    guard let selectedViewController = tabBarController?.selectedViewController else { return }
    let repositoryDetailVC = RepositoryDetailRouter.createModule(for: repository)
    repositoryDetailVC.modalPresentationStyle = .overCurrentContext
    repositoryDetailVC.transitioningDelegate = repositoryDetailTransitioningDelegate
    selectedViewController.present(repositoryDetailVC, animated: true, completion: nil)
  }
  
  func presentLoginPopup() {
    guard let selectedViewController = tabBarController?.selectedViewController else { return }
    
    let action = UIAlertAction(title: "Log in", style: .default) { [weak self] action in
      self?.tabBarController?.dismiss(animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    AlertView.show(title: "Unauthorized user",
                   message: "Search is available only for authorized users.",
                   action: action,
                   cancelAction: cancelAction,
                   in: selectedViewController)
  }
  
  func presentSettingsPopup() {
    guard let selectedViewController = tabBarController?.selectedViewController else { return }
    
    let action = UIAlertAction(title: "Settings", style: .default) { action in
      if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
        if UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
      }
    }
    
    let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    AlertView.show(title: "Offline mode",
                   message: "Search is not available in offline mode. Turn on cellular data or use Wi-Fi.",
                   action: action,
                   cancelAction: cancelAction,
                   in: selectedViewController)
  }
  
}

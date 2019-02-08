import UIKit

protocol RepositoriesRouterInterface: class {
  var presenter: RepositoriesPresenterInterface? { get set }
  var tabBarController: UITabBarController? { get set }
  
  static func createModule() -> UIViewController
  // PRESENTER -> ROUTER
  func presentPopup(title: String?, message: String?)
  func presentRepositoryDetailScreen(for repository: Repository)
  func presentLoginPopup()
  func presentSettingsPopup()
}

protocol RepositoriesViewInterface: class {
  var presenter: RepositoriesPresenterInterface? { get set }
  
  // PRESENTER -> VIEW
  func observeReachability()
}

protocol RepositoriesPresenterInterface: class {
  var view: RepositoriesViewInterface? { get set }
  var router: RepositoriesRouterInterface? { get set }
  
  // VIEW -> PRESENTER
  func viewWillAppear()
}

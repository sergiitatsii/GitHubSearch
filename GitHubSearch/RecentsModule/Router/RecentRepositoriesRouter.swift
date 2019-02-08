import UIKit

class RecentRepositoriesRouter: RecentRepositoriesRouterInterface {
  
  weak var presenter: RecentRepositoriesPresenterInterface?
  weak var navigationController: UINavigationController?
  var parentRouter: RepositoriesRouterInterface?
  
  static func createModule(with parentRouter: RepositoriesRouterInterface? = nil) -> UIViewController {
    // Create layers
    guard let view = RecentRepositoriesViewController.instantiate(storyboardName: "Repositories") else { return UIViewController() }
    view.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
    let navigationController = UINavigationController(rootViewController: view)
    let presenter: RecentRepositoriesPresenterInterface & RecentRepositoriesInteractorOutputInterface = RecentRepositoriesPresenter()
    let interactor: RecentRepositoriesInteractorInputInterface = RecentRepositoriesInteractor()
    let realmStorage: Storage = try! RealmStorage()
    let router: RecentRepositoriesRouterInterface = RecentRepositoriesRouter()
    
    // Connect layers
    view.presenter = presenter
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.presenter = presenter
    interactor.storage = realmStorage
    router.presenter = presenter
    router.navigationController = navigationController
    router.parentRouter = parentRouter
    
    return navigationController
  }
  
  func presentRepositoryDetailScreen(for repository: Repository) {
    parentRouter?.presentRepositoryDetailScreen(for: repository)
  }
  
  func presentPopup(with error: Error) {
    guard let visibleViewController = navigationController?.visibleViewController else { return }
    AlertView.show(title: "Ooops!", message: error.localizedDescription, in: visibleViewController)
  }
  
}

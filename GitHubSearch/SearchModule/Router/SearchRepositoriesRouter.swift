import UIKit

class SearchRepositoriesRouter: SearchRepositoriesRouterInterface {
  
  weak var presenter: SearchRepositoriesPresenterInterface?
  weak var navigationController: UINavigationController?
  var parentRouter: RepositoriesRouterInterface?
  
  static func createModule(with parentRouter: RepositoriesRouterInterface? = nil) -> UIViewController {
    // Create layers
    guard let view = SearchRepositoriesViewController.instantiate(storyboardName: "Repositories") else { return UIViewController() }
    view.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
    let navigationController = UINavigationController(rootViewController: view)
    let presenter = SearchRepositoriesPresenter()
    let interactor = SearchRepositoriesInteractor()
    let searchManager = SearchRepositoriesManager()
    let realmStorage = try! RealmStorage()
    let router = SearchRepositoriesRouter()
    
    // Connect layers
    view.presenter = presenter
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.presenter = presenter
    interactor.searchManager = searchManager
    interactor.storage = realmStorage
    searchManager.searchHandler = interactor
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

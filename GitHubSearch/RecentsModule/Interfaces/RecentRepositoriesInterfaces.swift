import UIKit

protocol RecentRepositoriesRouterInterface: class {
  var presenter: RecentRepositoriesPresenterInterface? { get set }
  var navigationController: UINavigationController? { get set }
  var parentRouter: RepositoriesRouterInterface? { get set }
  
  static func createModule(with parentRouter: RepositoriesRouterInterface?) -> UIViewController
  // PRESENTER -> ROUTER
  func presentRepositoryDetailScreen(for repository: Repository)
  func presentPopup(with error: Error)
}

protocol RecentRepositoriesViewInterface: class {
  var presenter: RecentRepositoriesPresenterInterface? { get set }
  var repositories: [Repository] { get set }
  
  // PRESENTER -> VIEW
  func setupInitialView()
  func showLoading()
  func hideLoading()
  func showRepositories()
  func showNoContentView()
  func showError(_ error: Error)
}

protocol RecentRepositoriesPresenterInterface: class {
  var view: RecentRepositoriesViewInterface? { get set }
  var interactor: RecentRepositoriesInteractorInputInterface? { get set }
  var router: RecentRepositoriesRouterInterface? { get set }
  
  // VIEW -> PRESENTER
  func viewDidLoad()
  func viewWillAppear()
  func showRepositoryDetail(for repository: Repository)
  func removeRepository(at indexPath: IndexPath, completion: ((Bool) -> ())?)
  func moveRepository(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, completion: ((Bool) -> ())?)
  func markRepositoryAsViewed(at indexPath: IndexPath, completion: ((Bool) -> ())?)
}

protocol RecentRepositoriesInteractorInputInterface: class {
  var presenter: RecentRepositoriesInteractorOutputInterface? { get set }
  var storage: Storage? { get set }
  
  // PRESENTER -> INTERACTOR
  func retrieveRecentRepositories()
  func removeRepository(at indexPath: IndexPath, completion: ((Bool) -> ())?)
  func moveRepository(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, completion: ((Bool) -> ())?)
  func markRepositoryAsViewed(at indexPath: IndexPath, completion: ((Bool) -> ())?)
}

protocol RecentRepositoriesInteractorOutputInterface: class {
  // INTERACTOR -> PRESENTER
  func didRetrieveRecentRepositories(_ repositories: [Repository])
  func didFailWithError(_ error: Error)
}

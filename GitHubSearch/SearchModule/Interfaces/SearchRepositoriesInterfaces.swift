import UIKit

protocol SearchRepositoriesRouterInterface: class {
  var presenter: SearchRepositoriesPresenterInterface? { get set }
  var navigationController: UINavigationController? { get set }
  var parentRouter: RepositoriesRouterInterface? { get set }
  
  static func createModule(with parentRouter: RepositoriesRouterInterface?) -> UIViewController
  // PRESENTER -> ROUTER
  func presentRepositoryDetailScreen(for repository: Repository)
  func presentPopup(with error: Error)
}

protocol SearchRepositoriesViewInterface: class {
  var presenter: SearchRepositoriesPresenterInterface? { get set }
  var repositories: [Repository] { get set }
  
  // PRESENTER -> VIEW
  func setupInitialView()
  func showLoading()
  func hideLoading()
  func showRepositories()
  func showNoContentView()
  func showError(_ error: Error)
}

protocol SearchRepositoriesPresenterInterface: class {
  var view: SearchRepositoriesViewInterface? { get set }
  var interactor: SearchRepositoriesInteractorInputInterface? { get set }
  var router: SearchRepositoriesRouterInterface? { get set }
  
  // VIEW -> PRESENTER
  func viewDidLoad()
  func viewWillAppear()
  func onSearchEvent(with text: String)
  func onCancelEvent()
  func shouldShowLoadingCell() -> Bool
  func showRepositoryDetail(for repository: Repository)
}

protocol SearchRepositoriesInteractorInputInterface: class {
  var presenter: SearchRepositoriesInteractorOutputInterface? { get set }
  var searchManager: SearchRepositoriesManagerInputInterface? { get set }
  var storage: (StorageCreateProtocol & StorageDeleteProtocol)? { get set }
  
  // PRESENTER -> INTERACTOR
  func searchRepositories(for keyword: String)
  func cancelSearch()
}

protocol SearchRepositoriesInteractorOutputInterface: class {
  // INTERACTOR -> PRESENTER
  func didFindRepositories(_ repositories: [Repository])
  func didFailWithError(_ error: Error)
}

protocol SearchRepositoriesManagerInputInterface: class {
  var searchHandler: SearchRepositoriesManagerOutputInterface? { get set }
  var isSearchCanceled: Bool { get }
  
  // INTERACTOR -> SEARCHREPOSITORIESMANAGER
  func searchRepositories(for keyword: String)
  func cancelSearch()
  func isNextPageAvailable() -> Bool
}

protocol SearchRepositoriesManagerOutputInterface: class {
  // SEARCHREPOSITORIESMANAGER -> INTERACTOR
  func onSuccess(_ repositories: [Repository])
  func onError(_ error: Error)
}

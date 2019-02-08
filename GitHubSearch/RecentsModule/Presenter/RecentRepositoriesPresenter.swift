import Foundation

class RecentRepositoriesPresenter: RecentRepositoriesPresenterInterface {
  
  weak var view: RecentRepositoriesViewInterface?
  var interactor: RecentRepositoriesInteractorInputInterface?
  var router: RecentRepositoriesRouterInterface?
  
  func viewDidLoad() {
    view?.setupInitialView()
  }
  
  func viewWillAppear() {
    view?.showLoading()
    interactor?.retrieveRecentRepositories()
  }
  
  func showRepositoryDetail(for repository: Repository) {
    router?.presentRepositoryDetailScreen(for: repository)
  }
  
  func removeRepository(at indexPath: IndexPath, completion: ((Bool) -> ())?) {
    interactor?.removeRepository(at: indexPath, completion: completion)
  }
  
  func moveRepository(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, completion: ((Bool) -> ())?) {
    interactor?.moveRepository(from: sourceIndexPath, to: destinationIndexPath, completion: completion)
  }
  
  func markRepositoryAsViewed(at indexPath: IndexPath, completion: ((Bool) -> ())?) {
    interactor?.markRepositoryAsViewed(at: indexPath, completion: completion)
  }
  
}

extension RecentRepositoriesPresenter: RecentRepositoriesInteractorOutputInterface {
  
  func didRetrieveRecentRepositories(_ repositories: [Repository]) {
    view?.hideLoading()
    view?.repositories = repositories
  }
  
  func didFailWithError(_ error: Error) {
    view?.hideLoading()
    view?.showError(error)
  }
  
}

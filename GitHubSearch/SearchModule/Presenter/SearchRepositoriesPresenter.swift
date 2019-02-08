import Foundation

class SearchRepositoriesPresenter: SearchRepositoriesPresenterInterface {
  
  weak var view: SearchRepositoriesViewInterface?
  var interactor: SearchRepositoriesInteractorInputInterface?
  var router: SearchRepositoriesRouterInterface?
  
  func viewDidLoad() {
    view?.setupInitialView()
  }
  
  func viewWillAppear() {
    
  }
  
  func onSearchEvent(with text: String) {
    view?.showLoading()
    interactor?.searchRepositories(for: text)
  }
  
  func onCancelEvent() {
    interactor?.cancelSearch()
  }
  
  func shouldShowLoadingCell() -> Bool {
    guard let searchManager = interactor?.searchManager else { return false }
    return searchManager.isNextPageAvailable() && !searchManager.isSearchCanceled
  }
  
  func showRepositoryDetail(for repository: Repository) {
    router?.presentRepositoryDetailScreen(for: repository)
  }
  
}

extension SearchRepositoriesPresenter: SearchRepositoriesInteractorOutputInterface {
  
  func didFindRepositories(_ repositories: [Repository]) {
    view?.hideLoading()
    view?.repositories = repositories
  }
  
  func didFailWithError(_ error: Error) {
    view?.hideLoading()
    view?.showError(error)
  }
  
}

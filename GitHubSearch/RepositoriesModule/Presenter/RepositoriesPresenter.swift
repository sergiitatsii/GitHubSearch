import Foundation

class RepositoriesPresenter: RepositoriesPresenterInterface {
  
  weak var view: RepositoriesViewInterface?
  var router: RepositoriesRouterInterface?
  
  func viewWillAppear() {
    view?.observeReachability()
  }
  
}

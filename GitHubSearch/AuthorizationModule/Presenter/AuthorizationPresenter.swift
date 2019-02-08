import UIKit

class AuthorizationPresenter: AuthorizationPresenterInterface {
  
  weak var view: AuthorizationViewInterface?
  var interactor: AuthorizationInteractorInputInterface?
  var router: AuthorizationRouterInterface?
  
  func viewDidLoad() {
    
  }
  
  func githubLoginPressed() {
    guard let viewController = view as? UIViewController else { return }
    view?.showLoading()
    interactor?.authorize(from: viewController)
  }
  
  func skipPressed() {
    interactor?.logout()
    presentRepositories()
  }
  
  private func presentRepositories() {
    guard let view = view else { return }
    DispatchQueue.main.async {
      self.router?.presentRepositories(from: view)
    }
  }
  
}

extension AuthorizationPresenter: AuthorizationInteractorOutputInterface {

  func didAuthorized(_ token: String) {
    view?.hideLoading()
    presentRepositories()
  }
  
  func failedWithError(_ error: Error) {
    DispatchQueue.main.async {
      self.view?.hideLoading()
      self.view?.showError(error)
    }
  }
  
}

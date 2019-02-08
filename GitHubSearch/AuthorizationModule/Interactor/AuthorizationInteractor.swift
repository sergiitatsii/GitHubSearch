import UIKit

class AuthorizationInteractor: AuthorizationInteractorInputInterface {
  
  weak var presenter: AuthorizationInteractorOutputInterface?
  var authorizationManager: AuthorizationManagerInputInterface?
  
  func authorize(from viewController: UIViewController) {
    authorizationManager?.authorize(from: viewController)
  }
  
  func logout() {
    SessionManager.shared.logout()
  }
  
}

extension AuthorizationInteractor: AuthorizationManagerOutputInterface {
  
  func onSuccess(_ token: String) {
    SessionManager.shared.update(token: token)
    presenter?.didAuthorized(token)
  }
  
  func onError(_ error: Error) {
    presenter?.failedWithError(error)
  }
  
}

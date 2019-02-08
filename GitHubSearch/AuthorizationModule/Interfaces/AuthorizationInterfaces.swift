import UIKit

protocol AuthorizationRouterInterface: class {
  static func createModule() -> UIViewController
  // PRESENTER -> ROUTER
  func presentRepositories(from view: AuthorizationViewInterface)
}

protocol AuthorizationViewInterface: class {
  var presenter: AuthorizationPresenterInterface? { get set }
  
  // PRESENTER -> VIEW
  func showLoading()
  func hideLoading()
  func showError(_ error: Error)
}

protocol AuthorizationPresenterInterface: class {
  var view: AuthorizationViewInterface? { get set }
  var interactor: AuthorizationInteractorInputInterface? { get set }
  var router: AuthorizationRouterInterface? { get set }
  
  // VIEW -> PRESENTER
  func viewDidLoad()
  func githubLoginPressed()
  func skipPressed()
}

protocol AuthorizationInteractorInputInterface: class {
  var presenter: AuthorizationInteractorOutputInterface? { get set }
  var authorizationManager: AuthorizationManagerInputInterface? { get set }
  
  // PRESENTER -> INTERACTOR
  func authorize(from viewController: UIViewController)
  func logout()
}

protocol AuthorizationInteractorOutputInterface: class {
  // INTERACTOR -> PRESENTER
  func didAuthorized(_ token: String)
  func failedWithError(_ error: Error)
}

protocol AuthorizationManagerInputInterface: class {
  var authorizationHandler: AuthorizationManagerOutputInterface? { get set }
  
  // INTERACTOR -> AUTHORIZATIONMANAGER
  func authorize(from viewController: UIViewController)
}

protocol AuthorizationManagerOutputInterface: class {
  // AUTHORIZATIONMANAGER -> INTERACTOR
  func onSuccess(_ token: String)
  func onError(_ error: Error)
}

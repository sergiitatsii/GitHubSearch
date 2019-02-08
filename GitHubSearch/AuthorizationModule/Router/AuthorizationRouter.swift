import UIKit

class AuthorizationRouter: AuthorizationRouterInterface {
  
  static func createModule() -> UIViewController {
    guard let view = AuthorizationViewController.instantiate(initial: true) else { return UIViewController() }
    let navVC = UINavigationController(rootViewController: view)
    let presenter: AuthorizationPresenterInterface & AuthorizationInteractorOutputInterface = AuthorizationPresenter()
    let interactor: AuthorizationInteractorInputInterface & AuthorizationManagerOutputInterface = AuthorizationInteractor()
    let authorizationManager: AuthorizationManagerInputInterface = AuthorizationManager()
    let router: AuthorizationRouterInterface = AuthorizationRouter()
    
    view.presenter = presenter
    presenter.view = view
    presenter.router = router
    presenter.interactor = interactor
    interactor.presenter = presenter
    interactor.authorizationManager = authorizationManager
    authorizationManager.authorizationHandler = interactor
    
    return navVC
  }
  
  func presentRepositories(from view: AuthorizationViewInterface) {
    let repositoriesVC = RepositoriesRouter.createModule()
    
    guard let sourceView = view as? UIViewController else { return }
    sourceView.navigationController?.present(repositoriesVC, animated: true, completion: nil) //pushViewController(repositoriesViewController, animated: true)
  }
  
}

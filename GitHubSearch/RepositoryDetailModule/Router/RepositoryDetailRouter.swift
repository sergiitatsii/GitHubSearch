import UIKit

class RepositoryDetailRouter: RepositoryDetailRouterInterface {
  
  weak var presenter: RepositoryDetailPresenterInterface?
  
  static func createModule(for repository: Repository) -> UIViewController {
    // Create layers
    guard let view = RepositoryDetailViewController.instantiate() else { return UIViewController() }
    let presenter = RepositoryDetailPresenter()
    let router = RepositoryDetailRouter()
    
    // Connect layers
    view.presenter = presenter
    presenter.view = view
    presenter.repository = repository
    presenter.router = router
    router.presenter = presenter
    
    return view
  }
  
}

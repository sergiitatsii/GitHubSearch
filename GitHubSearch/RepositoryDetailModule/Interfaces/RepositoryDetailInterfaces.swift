import UIKit

protocol RepositoryDetailRouterInterface: class {
  var presenter: RepositoryDetailPresenterInterface? { get set }
  
  static func createModule(for repository: Repository) -> UIViewController
  // PRESENTER -> ROUTER
}

protocol RepositoryDetailViewInterface: class {
  var presenter: RepositoryDetailPresenterInterface? { get set }
  
  // PRESENTER -> VIEW
  func setupInitialView()
  func showRepositoryDetail(for repository: Repository)
  func hideRepositoryDetail()
}

protocol RepositoryDetailPresenterInterface: class {
  var view: RepositoryDetailViewInterface? { get set }
  var router: RepositoryDetailRouterInterface? { get set }
  var repository: Repository? { get set }
  
  // VIEW -> PRESENTER
  func viewDidLoad()
  func initialViewDidSetup()
  func closePressed()
}

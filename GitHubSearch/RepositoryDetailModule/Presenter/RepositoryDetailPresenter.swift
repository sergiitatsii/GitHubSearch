import UIKit

class RepositoryDetailPresenter: RepositoryDetailPresenterInterface {
  
  weak var view: RepositoryDetailViewInterface?
  var router: RepositoryDetailRouterInterface?
  var repository: Repository?
  
  func viewDidLoad() {
    view?.setupInitialView()
  }
  
  func initialViewDidSetup() {
    view?.showRepositoryDetail(for: repository!)
  }
  
  func closePressed() {
    view?.hideRepositoryDetail()
  }
  
}

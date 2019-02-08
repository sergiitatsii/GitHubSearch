import UIKit
import PKHUD
import OAuthSwift

class AuthorizationViewController: UIViewController {
  
  @IBOutlet weak var githubLoginButton: UIButton!
  @IBOutlet weak var skipButton: UIButton!
  
  var presenter: AuthorizationPresenterInterface?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Login"
    presenter?.viewDidLoad()
  }
  
  @IBAction func githubLoginButtonPressed(_ sender: Any) {
    presenter?.githubLoginPressed()
  }
  
  @IBAction func skipButtonPressed(_ sender: Any) {
    presenter?.skipPressed()
  }
  
}

extension AuthorizationViewController: AuthorizationViewInterface {
  
  func showLoading() {
    //HUD.show(.progress)
  }
  
  func hideLoading() {
    //HUD.hide()
  }
  
  func showError(_ error: Error) {
    HUD.flash(.labeledError(title: "Ooops!", subtitle: error.localizedDescription), delay: 2.0)
  }
  
}

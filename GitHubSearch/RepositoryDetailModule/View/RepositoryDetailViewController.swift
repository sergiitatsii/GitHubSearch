import UIKit
import WebKit

class RepositoryDetailViewController: UIViewController, WKUIDelegate {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var closeButton: UIButton!
  var webView: WKWebView!
  
  var presenter: RepositoryDetailPresenterInterface?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.viewDidLoad()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    presenter?.closePressed()
  }
  
  @IBAction func closeButtonPressed(_ sender: Any) {
    presenter?.closePressed()
  }
  
  @IBAction func handleTap(_ sender: Any) {
    presenter?.closePressed()
  }
  
}

// MARK: - RepositoryDetailViewInterface
extension RepositoryDetailViewController: RepositoryDetailViewInterface {
  
  func setupInitialView() {
    webView = WKWebView()
    webView.backgroundColor = UIColor.GitHubSearch.lightGray
    webView.isOpaque = false
    containerView.addSubview(webView)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
    webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    webView.uiDelegate = self
    
    presenter?.initialViewDidSetup()
  }
  
  func showRepositoryDetail(for repository: Repository) {
    webView.load(URLRequest(url: repository.url))
  }
  
  func hideRepositoryDetail() {
    dismiss(animated: true, completion: nil)
  }
  
}

import UIKit
import NVActivityIndicatorView
import PKHUD

class RecentRepositoriesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noContentLabel: UILabel!
  @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
  var editButton: UIBarButtonItem?
  
  var presenter: RecentRepositoriesPresenterInterface?
  
  var repositories: [Repository] = [] {
    didSet {
      if repositories.count > 0 {
        showRepositories()
      } else {
        showNoContentView()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.viewWillAppear()
  }
  
  // MARK: - Private Methods
  private func setupNavigationBar() {
    navigationItem.title = "Recent"
    editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode))
    navigationItem.rightBarButtonItem = editButton
  }
  
  private func setupTableView() {
    tableView.register(cellClass: RepositoryTableViewCell.self)
    tableView.estimatedRowHeight = 60.0
    tableView.rowHeight = 60
    noContentLabel.isHidden = true
  }
  
  private func showViewWith(emptyContent: Bool) {
    UIView.animate(withDuration: 0.3) {
      self.tableView.isHidden = emptyContent
      self.noContentLabel.isHidden = !emptyContent
    }
  }
  
  @objc private func toggleEditingMode() {
    tableView.setEditing(!tableView.isEditing, animated: true)
    editButton?.title = tableView.isEditing ? "Done" : "Edit"
  }
  
}

// MARK: - RecentRepositoriesViewInterface
extension RecentRepositoriesViewController: RecentRepositoriesViewInterface {
  
  func setupInitialView() {
    setupNavigationBar()
    setupTableView()
  }
  
  func showLoading() {
    activityIndicator.startAnimating()
  }
  
  func hideLoading() {
    activityIndicator.stopAnimating()
  }
  
  func showRepositories() {
    tableView.reloadData()
    showViewWith(emptyContent: false)
    editButton?.isEnabled = true
  }
  
  func showNoContentView() {
    tableView.reloadData()
    showViewWith(emptyContent: true)
    editButton?.isEnabled = false
  }
  
  func showError(_ error: Error) {
    HUD.flash(.labeledError(title: "Ooops!", subtitle: error.localizedDescription), delay: 2.0)
  }
  
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension RecentRepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.self.reuseID) as! RepositoryTableViewCell
    let repository = repositories[indexPath.row]
    cell.model = repository
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedRepository = repositories[indexPath.row]
    presenter?.showRepositoryDetail(for: selectedRepository)
    presenter?.markRepositoryAsViewed(at: indexPath, completion: { [weak self] succeeded in
      if succeeded {
        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
      }
    })
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      presenter?.removeRepository(at: indexPath, completion: { [weak self] succeeded in
        if succeeded {
          self?.tableView.beginUpdates()
          self?.repositories.remove(at: indexPath.row)
          self?.tableView.deleteRows(at: [indexPath], with: .fade)
          self?.tableView.endUpdates()
        }
      })
    }
  }
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let sourceRepository = repositories[sourceIndexPath.row]
    presenter?.moveRepository(from: sourceIndexPath, to: destinationIndexPath, completion: { [weak self] succeeded in
      if succeeded {
        self?.repositories.remove(at: sourceIndexPath.row)
        self?.repositories.insert(sourceRepository, at: destinationIndexPath.row)
      }
    })
  }
  
}

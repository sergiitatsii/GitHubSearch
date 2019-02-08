import UIKit
import PKHUD
import NVActivityIndicatorView


class SearchRepositoriesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noContentLabel: UILabel!
  @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
  
  var searchController: SearchController!
  
  var presenter: SearchRepositoriesPresenterInterface?
  
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
    definesPresentationContext = true
    presenter?.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.viewWillAppear()
  }
  
  // MARK: - Private Methods
  private func setupSearchController() {
    searchController = SearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    //searchController.dimsBackgroundDuringPresentation = false
    //searchController.hidesNavigationBarDuringPresentation = false
    //searchController.searchBar.searchBarStyle = .minimal
    //searchController.searchBar.sizeToFit()
    searchController.throttledSearchBar.throttlingInterval = 0.5
    searchController.throttledSearchBar.onCancel = { [weak self] in
      self?.presenter?.onCancelEvent()
    }
    
    searchController.throttledSearchBar.onSearch = { [weak self] text in
      self?.presenter?.onSearchEvent(with: text)
    }
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.hidesSearchBarWhenScrolling = true
    navigationItem.searchController = searchController
    navigationItem.title = "GitHub Repositories"
  }
  
  private func setupTableView() {
    tableView.register(cellClass: RepositoryTableViewCell.self)
    tableView.register(cellClass: LoadingTableViewCell.self)
    //tableView.tableHeaderView = searchController.searchBar
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
  
  private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
    guard
      let shouldShowLoadingCell = presenter?.shouldShowLoadingCell(),
      shouldShowLoadingCell == true
    else { return false }
    return indexPath.row == repositories.count
  }
  
  private func fetchNextPage() {
    guard let text = searchController.searchBar.text else { return }
    presenter?.onSearchEvent(with: text)
  }
  
}

// MARK: - SearchRepositoriesViewInterface
extension SearchRepositoriesViewController: SearchRepositoriesViewInterface {
  
  func setupInitialView() {
    setupSearchController()
    setupNavigationBar()
    setupTableView()
  }
  
  func showRepositories() {
    tableView.reloadData()
    showViewWith(emptyContent: false)
  }
  
  func showNoContentView() {
    tableView.reloadData()
    showViewWith(emptyContent: true)
  }
  
  func showLoading() {
    //HUD.show(.progress)
    activityIndicator.startAnimating()
  }
  
  func hideLoading() {
    //HUD.hide()
    activityIndicator.stopAnimating()
  }
  
  func showError(_ error: Error) {
    HUD.flash(.labeledError(title: "Ooops!", subtitle: error.localizedDescription), delay: 2.0)
  }
  
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchRepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let shouldShowLoadingCell = presenter?.shouldShowLoadingCell() else {
      return repositories.count
    }
    return shouldShowLoadingCell ? repositories.count + 1 : repositories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if isLoadingIndexPath(indexPath) {
      return tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.self.reuseID) as! LoadingTableViewCell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableViewCell.self.reuseID) as! RepositoryTableViewCell
      let repository = repositories[indexPath.row]
      cell.model = repository
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedRepository = repositories[indexPath.row]
    presenter?.showRepositoryDetail(for: selectedRepository)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard isLoadingIndexPath(indexPath) else { return }
    fetchNextPage()
  }
  
}

// MARK: - UISearchResultsUpdating
extension SearchRepositoriesViewController: UISearchResultsUpdating {
  
  // Use `onSearch` closure of SearchController's SearchBar instead of this method. It has a built-in input throttling.
  func updateSearchResults(for searchController: UISearchController) {
    //presenter?.onSearchEvent(with: searchController.searchBar.text ?? "")
  }
  
}

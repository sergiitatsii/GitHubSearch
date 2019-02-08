import Foundation

class SearchRepositoriesManager: SearchRepositoriesManagerInputInterface {
  
  var searchHandler: SearchRepositoriesManagerOutputInterface?
  
  private var repositoriesProvider: RepositoriesProvider?
  private var searchTerm: String?
  private var currentPage: Page<Repository>?
  private var repositories = [Repository]()
  private(set) var isSearchCanceled = false
  
  func searchRepositories(for keyword: String) {
    isSearchCanceled = false
    var pageNumber = 1 // by default
    
    if keyword == searchTerm, isNextPageAvailable(), let index = currentPage?.index {
      // if we're loading next page
      pageNumber = index + 1
    }
    
    repositoriesProvider = RepositoriesProvider(keyword: keyword, pageNumber: pageNumber) { [weak self] pageOrNil, repositories in
      guard let strongSelf = self, let newPage = pageOrNil else {
        DispatchQueue.main.async {
          self?.searchHandler?.onSuccess([])
        }
        return
      }
      print("newPage.totalCount = \(newPage.totalCount)")
      print("pageNumber = \(pageNumber)")
      strongSelf.searchTerm = keyword
      strongSelf.currentPage = newPage
      strongSelf.currentPage?.index = pageNumber
      
      if pageNumber == 1 {
        strongSelf.repositories = repositories
      } else {
        strongSelf.repositories.appendWithoutDuplicates(contentsOf: repositories)
      }
      
      DispatchQueue.main.async {
        strongSelf.searchHandler?.onSuccess(strongSelf.repositories)
      }
    }
  }
  
  func cancelSearch() {
    repositoriesProvider?.cancel()
    isSearchCanceled = true
    searchHandler?.onSuccess(repositories)
  }
  
  func isNextPageAvailable() -> Bool {
    guard let totalCount = currentPage?.totalCount else { return false }
    return repositories.count < totalCount
  }
  
}

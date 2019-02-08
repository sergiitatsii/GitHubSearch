import Foundation

class SearchRepositoriesInteractor: SearchRepositoriesInteractorInputInterface {
  
  weak var presenter: SearchRepositoriesInteractorOutputInterface?
  var searchManager: SearchRepositoriesManagerInputInterface?
  var storage: (StorageCreateProtocol & StorageDeleteProtocol)?
  
  func searchRepositories(for keyword: String) {
    if keyword.count > 0 {
      searchManager?.searchRepositories(for: keyword)
    } else {
      searchManager?.cancelSearch()
    }
  }

  func cancelSearch() {
    searchManager?.cancelSearch()
  }
  
}

extension SearchRepositoriesInteractor: SearchRepositoriesManagerOutputInterface {
  
  func onSuccess(_ repositories: [Repository]) {
    presenter?.didFindRepositories(repositories)
    
    guard repositories.count > 0 else { return }
    
    do {
      try storage?.deleteAll(Repository.self)
    } catch {
      presenter?.didFailWithError(error)
    }
    
    for i in 0..<repositories.count {
      do {
        try storage?.create(Repository.self, completion: { newRepository in
          newRepository.id = repositories[i].id
          newRepository.name = repositories[i].name
          newRepository.urlString = repositories[i].urlString
          newRepository.displayIndex = i
        })
      } catch {
        presenter?.didFailWithError(error)
      }
    }
  }
  
  func onError(_ error: Error) {
    presenter?.didFailWithError(error)
  }
  
}

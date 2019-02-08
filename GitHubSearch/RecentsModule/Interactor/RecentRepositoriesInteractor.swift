import Foundation

class RecentRepositoriesInteractor: RecentRepositoriesInteractorInputInterface {
  
  weak var presenter: RecentRepositoriesInteractorOutputInterface?
  var storage: Storage?
  
  func retrieveRecentRepositories() {
    repositoriesSortedByDisplayIndex { [weak self] repositories in
      self?.presenter?.didRetrieveRecentRepositories(repositories)
    }
  }
  
  func removeRepository(at indexPath: IndexPath, completion: ((Bool) -> ())?) {
    repositoriesSortedByDisplayIndex { [weak self] repositories in
      let repositoryToDelete = repositories[indexPath.row]
      
      do {
        try self?.storage?.delete(object: repositoryToDelete)
        completion?(true)
        self?.updateRepositoriesDisplayIndexes()
      } catch {
        self?.presenter?.didFailWithError(error)
        completion?(false)
      }
    }
  }
  
  func moveRepository(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, completion: ((Bool) -> ())?) {
    let fromIndex = sourceIndexPath.row
    let toIndex = destinationIndexPath.row
    
    guard fromIndex != toIndex else {
      completion?(false)
      return
    }
    
    repositoriesSortedByDisplayIndex { [weak self] repositories in
      let repositoryToMove = repositories[fromIndex]
      do {
        try self?.storage?.update {
          repositoryToMove.displayIndex = toIndex
        }
      } catch {
        self?.presenter?.didFailWithError(error)
        completion?(false)
        return
      }
      
      var start, end, delta: Int
      
      if fromIndex < toIndex {
        start = fromIndex + 1
        end = toIndex
        delta = -1
      } else {
        start = toIndex
        end = fromIndex - 1
        delta = 1
      }
      
      for i in start...end {
        let repository = repositories[i]
        do {
          try self?.storage?.update {
            repository.displayIndex += delta
          }
        } catch {
          self?.presenter?.didFailWithError(error)
          completion?(false)
          return
        }
      }
      
      completion?(true)
    }
  }
  
  func markRepositoryAsViewed(at indexPath: IndexPath, completion: ((Bool) -> ())?) {
    repositoriesSortedByDisplayIndex { [weak self] repositories in
      let repositoryToMark = repositories[indexPath.row]
      do {
        try self?.storage?.update {
          repositoryToMark.isViewed = true
        }
        completion?(true)
      } catch {
        self?.presenter?.didFailWithError(error)
        completion?(false)
      }
    }
  }
  
  // MARK: - Private Methods
  private func repositoriesSortedByDisplayIndex(_ completion: (([Repository]) -> Void)) {
    let sorted = Sorted(key: "displayIndex", ascending: true)
    storage?.fetch(Repository.self, predicate: nil, sorted: sorted, completion: { repositories in
      completion(repositories)
    })
  }
  
  private func updateRepositoriesDisplayIndexes() {
    repositoriesSortedByDisplayIndex { [weak self] repositories in
      for i in 0..<repositories.count {
        do {
          try self?.storage?.update {
            repositories[i].displayIndex = i
          }
        } catch {
          self?.presenter?.didFailWithError(error)
        }
      }
    }
  }
  
}

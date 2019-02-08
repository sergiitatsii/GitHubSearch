import Foundation

class RepositoriesSearchOperation: AsyncOperation {
  
  let keyword: String
  let pageNumber: Int
  let takeFromBeginning: Bool
  var retrievedPage: Page<Repository>?
  private(set) var items = [Repository]()
  
  init(keyword: String, pageNumber: Int, takeFromBeginning: Bool = true) {
    self.keyword = keyword
    self.pageNumber = pageNumber
    self.takeFromBeginning = takeFromBeginning
    super.init()
  }
  
  override func main() {
    if self.isCancelled { return }
    GitHubAPI.searchRepositories(with: keyword, page: pageNumber) { [unowned self] pageOrNil, errorOrNil in
      if self.isCancelled { return }
      
      guard let newPage = pageOrNil else {
        print("'\(#function)' failed with error: \(errorOrNil!.localizedDescription)")
        self.state = .finished
        return
      }
      
      var items = [Repository]()
      let itemsCount = newPage.items.count/2
      
      if newPage.items.count % 2 == 0 {
        items = self.takeFromBeginning ? Array(newPage.items.prefix(itemsCount)) : Array(newPage.items.suffix(itemsCount))
      } else {
        items = self.takeFromBeginning ? Array(newPage.items.prefix(itemsCount)) : Array(newPage.items.suffix(itemsCount + 1))
      }
      
      if self.isCancelled { return }
      
      self.retrievedPage = newPage
      self.items = items
      self.state = .finished
    }
  }
  
}

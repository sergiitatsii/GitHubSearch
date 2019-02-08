import Foundation

class RepositoriesProvider {
  
  private let queue = OperationQueue()
  private let appendQueue = OperationQueue()
  private var firstSearchOperation: RepositoriesSearchOperation?
  private var secondSearchOperation: RepositoriesSearchOperation?
  let keyword: String
  let pageNumber: Int
  var retrievedPage: Page<Repository>?
  private(set) var items = [Repository]()
  
  init(keyword: String, pageNumber: Int, completion: @escaping (Page<Repository>?, [Repository]) -> ()) {
    self.keyword = keyword
    self.pageNumber = pageNumber
    
    queue.maxConcurrentOperationCount = 2
    appendQueue.maxConcurrentOperationCount = 1
    
    let firstSearchOperation = RepositoriesSearchOperation(keyword: keyword, pageNumber: pageNumber)
    firstSearchOperation.completionBlock = {
      print("*** firstSearchOperation finished:")
      self.appendQueue.addOperation {
        print("\(firstSearchOperation.items.count) items found.")
        self.items = firstSearchOperation.items
      }
    }
    
    let secondSearchOperation = RepositoriesSearchOperation(keyword: keyword, pageNumber: pageNumber, takeFromBeginning: false)
    secondSearchOperation.completionBlock = {
      print("*** secondSearchOperation finished:")
      self.appendQueue.addOperation {
        print("\(secondSearchOperation.items.count) items found.")
        self.retrievedPage = secondSearchOperation.retrievedPage
        self.items += secondSearchOperation.items
        completion(self.retrievedPage, self.items)
      }
    }
    
    self.firstSearchOperation = firstSearchOperation
    self.secondSearchOperation = secondSearchOperation
    
    let operations = [firstSearchOperation, secondSearchOperation]
    secondSearchOperation.addDependency(firstSearchOperation)
    queue.addOperations(operations, waitUntilFinished: false)
  }
  
  func cancel() {
    queue.cancelAllOperations()
  }
  
}

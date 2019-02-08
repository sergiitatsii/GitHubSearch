import Foundation

extension TimeInterval {
  
  /**
   Checks if `since` has passed since `self`.
   
   - Parameter since: The duration of time that needs to have passed for this function to return `true`.
   - Returns: `true` if `since` has passed since now.
   */
  func hasPassed(since: TimeInterval) -> Bool {
    return Date().timeIntervalSinceReferenceDate - self > since
  }
  
}

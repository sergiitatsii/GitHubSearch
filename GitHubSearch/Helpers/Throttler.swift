import UIKit

public class Throttler {
  
  private let queue: DispatchQueue = DispatchQueue.global(qos: .utility)
  
  private var job: DispatchWorkItem = DispatchWorkItem(block: {})
  private var previousRun: Date = Date.distantPast
  private var maxInterval: TimeInterval
  
  init(timeInterval: TimeInterval) {
    self.maxInterval = timeInterval
  }
  
  func throttle(closure: @escaping () -> ()) {
    job.cancel()
    job = DispatchWorkItem() { [weak self] in
      self?.previousRun = Date()
      closure()
    }
    let delay = maxInterval//Date().timeIntervalSince(previousRun) > maxInterval ? 0 : maxInterval
    queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
  }
}

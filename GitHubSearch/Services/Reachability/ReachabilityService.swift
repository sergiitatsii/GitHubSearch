import Foundation
import Reachability

protocol ReachabilityServiceType {
  var isConnected: Bool { get }
  func start()
  func stop()
}

class ReachabilityService: ReachabilityServiceType {
  
  static let shared = ReachabilityService()
  
  private let reachability = try! Reachability()
  
  private init() {}
  
  var isConnected: Bool {
    return reachability.connection != .unavailable
  }
  
  var whenReachable: ((Reachability) -> ())? {
    didSet {
      reachability.whenReachable = whenReachable
    }
  }
  
  var whenUnreachable: ((Reachability) -> ())? {
    didSet {
      reachability.whenUnreachable = whenUnreachable
    }
  }
  
  func start() {
    do {
      try reachability.startNotifier()
    } catch {
      print("Unable to start ReachabilityService notifier.")
    }
  }
  
  func stop() {
    reachability.stopNotifier()
  }
  
}

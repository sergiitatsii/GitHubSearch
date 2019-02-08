import Foundation
import UIKit

/// Helper function for reading service parameters from .plist file.
func plistValues(bundle: Bundle) -> (consumerKey: String, consumerSecret: String, authorizeUrl: String, accessTokenUrl: String, responseType: String)?
{
  guard
    let path = bundle.path(forResource: "GitHubAuth", ofType: "plist"),
    let values = NSDictionary(contentsOfFile: path) as? [String: Any]
    else {
      print("Missing GitHubAuth.plist file with service parameters in main bundle!")
      return nil
  }
  
  guard
    let consumerKey = values["consumerKey"] as? String,
    let consumerSecret = values["consumerSecret"] as? String,
    let authorizeUrl = values["authorizeUrl"] as? String,
    let accessTokenUrl = values["accessTokenUrl"] as? String,
    let responseType = values["responseType"] as? String
  else {
    print("GitHubAuth.plist file at \(path) is missing 'consumerKey' and/or 'consumerSecret' and/or 'authorizeUrl' and/or 'accessTokenUrl' and/or 'responseType' entries!")
    print("File currently has the following entries: \(values)")
    return nil
  }
  
  return (consumerKey: consumerKey,
          consumerSecret: consumerSecret,
          authorizeUrl: authorizeUrl,
          accessTokenUrl: accessTokenUrl,
          responseType: responseType)
}

/**
 Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
 
 - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to throttle.
 
 - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
 */
func throttle(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
  var currentWorkItem: DispatchWorkItem?
  var lastFire: TimeInterval = 0
  return {
    guard currentWorkItem == nil else { return }
    currentWorkItem = DispatchWorkItem {
      action()
      lastFire = Date().timeIntervalSinceReferenceDate
      currentWorkItem = nil
    }
    delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
  }
}

/**
 Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
 
 Accepts an `action` with one argument.
 - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to throttle. Can accept one argument.
 - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
 */
func throttle1<T>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
  var currentWorkItem: DispatchWorkItem?
  var lastFire: TimeInterval = 0
  return { (p1: T) in
    guard currentWorkItem == nil else { return }
    currentWorkItem = DispatchWorkItem {
      action(p1)
      lastFire = Date().timeIntervalSinceReferenceDate
      currentWorkItem = nil
    }
    delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
  }
}

/**
 Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
 Accepts an `action` with two arguments.
 - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to throttle. Can accept two arguments.
 - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
 */

func throttle2<T, U>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T, U) -> Void)) -> (T, U) -> Void {
  var currentWorkItem: DispatchWorkItem?
  var lastFire: TimeInterval = 0
  return { (p1: T, p2: U) in
    guard currentWorkItem == nil else { return }
    currentWorkItem = DispatchWorkItem {
      action(p1, p2)
      lastFire = Date().timeIntervalSinceReferenceDate
      currentWorkItem = nil
    }
    delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
  }
}

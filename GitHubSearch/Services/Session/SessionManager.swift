import Foundation
import KeychainAccess

class SessionManager {
  
  static let shared = SessionManager()
  
  let keychain = Keychain(service: "com.sergiitatsii.GitHubSearch")
  
  var authToken: String? {
    guard let token = keychain["authToken"] else { return nil }
    return token
  }
  
  var isAuthorized: Bool {
    return authToken != nil
  }
  
  private init () {}
  
  func update(token: String?) {
    keychain["authToken"] = token
  }
  
  func logout() {
    update(token: nil)
  }
  
}

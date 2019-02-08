import Foundation
import SafariServices
import OAuthSwift

enum AuthorizationError: Error {
  case authorizationDidCanceled
  case invalidPlist
  case invalidCallbackURL
}

class AuthorizationManager: AuthorizationManagerInputInterface {
  
  var authorizationHandler: AuthorizationManagerOutputInterface?
  var oauthswift: OAuthSwift?
  
  func authorize(from viewController: UIViewController) {
    guard let clientInfo = plistValues(bundle: Bundle.main) else {
      authorizationHandler?.onError(AuthorizationError.invalidPlist)
      return
    }
    
    let oauthswift = OAuth2Swift(
      consumerKey: clientInfo.consumerKey,
      consumerSecret: clientInfo.consumerSecret,
      authorizeUrl: clientInfo.authorizeUrl,
      accessTokenUrl: clientInfo.accessTokenUrl,
      responseType: clientInfo.responseType
    )
    
    self.oauthswift = oauthswift
    oauthswift.authorizeURLHandler = getURLHandler(for: viewController)
    let state = generateState(withLength: 20)
    
    guard let callbackURL = URL(string: "github-search://oauth-callback/github") else {
      authorizationHandler?.onError(AuthorizationError.invalidCallbackURL)
      return
    }
    
    let _ = oauthswift.authorize(
      withCallbackURL: callbackURL,
      scope: "user, repo",
      state: state,
      success: { [weak self] credential, response, parameters in
        guard let `self` = self else { return }
        print("Logged in with token: \(credential.oauthToken)")
        self.authorizationHandler?.onSuccess(credential.oauthToken)
    },
      failure: { [weak self] error in
        guard let `self` = self else { return }
        print("'\(#function)' failed with error: \(error)")
        self.authorizationHandler?.onError(error)
    })
  }
  
  // MARK: - Private Methods
  private func getURLHandler(for viewController: UIViewController) -> OAuthSwiftURLHandlerType {
    guard let oauthswift = oauthswift else { return OAuthSwiftOpenURLExternally.sharedInstance }
    
    let handler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)
    handler.presentCompletion = {
      print("Safari presented")
    }
    
    handler.dismissCompletion = {
      print("Safari dismissed")
    }
    
    handler.factory = { url in
      let controller = SFSafariViewController(url: url)
      // Customize it, for instance
      // controller.preferredBarTintColor = UIColor.red
      return controller
    }
    
    return handler
  }
  
}

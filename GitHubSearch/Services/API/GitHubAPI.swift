import Foundation

enum Method: String {
  case GET
  case POST
  case PUT
  case DELETE
}

enum Endpoint: String {
  case searchRepositories = "/search/repositories"
}

enum GitHubAPIError: Error {
  case invalidURL(String)
  case invalidParameter(String, Any)
  case requestFailed(Error)
  case jsonSerializationFailed(String)
  case jsonDecodingFailed(String)
  case noAuthToken
}

typealias Completion = (Page<Repository>?, GitHubAPIError?) -> Void

protocol GitHubAPIType {
  static func searchRepositories(with keyword: String,
                                 page: Int,
                                 completion: @escaping Completion)
}

class GitHubAPI: GitHubAPIType {
  
  private static let baseURL = URL(string:"https://api.github.com")
  static let perPage = 30

  // MARK: - Generic request
  private static func request(method: Method = .GET,
                              endpoint: String,
                              params: [String: Any] = [:],
                              authToken: String? = nil,
                              completion: @escaping (Data?, GitHubAPIError?) -> Void)
  {
    guard
      let url = baseURL?.appendingPathComponent(endpoint),
      var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else {
      completion(nil, .invalidURL(endpoint))
      return
    }
    
    var request = URLRequest(url: url)
    
    if method == .GET {
      var queryItems = [URLQueryItem]()
      for (key, value) in params {
        guard let v = value as? CustomStringConvertible else {
          completion(nil, .invalidParameter(key, value))
          return
        }
        queryItems.append(URLQueryItem(name: key, value: v.description))
      }
      components.queryItems = queryItems
      
      guard let finalURL = components.url else {
        completion(nil, .invalidURL(endpoint))
        return
      }
      request = URLRequest(url: finalURL)
    } else {
      guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
      else {
        completion(nil, .invalidParameter("httpBody", "serialization"))
        return
      }
      request.httpBody = jsonData
    }
    
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    if let token = authToken {
      request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    print("*** request = \(request)")
    URLSession.shared.dataTask(with: request, completionHandler: { dataOrNil, responseOrNil, errorOrNil in
      if let httpResponse = responseOrNil as? HTTPURLResponse {
        print("*** status code: (\(httpResponse.statusCode))")
      }
      if let error = errorOrNil {
        completion(nil, .requestFailed(error))
      } else if let data = dataOrNil {
        completion(data, nil)
        //let jsonString = String(data: data, encoding: .utf8)
        //print("*** jsonString = \(String(describing: jsonString))")
      }
    }).resume()
  }
  
  // MARK: - Public requests
  static func searchRepositories(with keyword: String,
                                 page: Int,
                                 completion: @escaping Completion)
  {
    guard let authToken = SessionManager.shared.authToken else {
      completion(nil, .noAuthToken)
      return
    }
    
    let params = ["q": keyword,
                  "sort": "stars",
                  "order": "desc",
                  "page": "\(page)",
                  "per_page": "\(perPage)"]
    
    GitHubAPI.request(method: .GET,
                      endpoint: Endpoint.searchRepositories.rawValue,
                      params: params,
                      authToken: authToken) { dataOrNil, errorOrNil in
                        if let error = errorOrNil {
                          print("'\(#function)' failed with error: \(error)")
                          completion(nil, error)
                        } else if let data = dataOrNil {
                          do {
                            let page = try JSONDecoder().decode(Page<Repository>.self, from: data)
                            completion(page, nil)
                          } catch {
                            completion(nil, .jsonDecodingFailed(error.localizedDescription))
                          }
                        }
    }
  }
  
}

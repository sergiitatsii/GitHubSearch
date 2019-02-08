import Foundation
import RealmSwift

class Repository: Object, Decodable {
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var urlString: String = ""
  @objc dynamic var displayIndex: Int = 0
  @objc dynamic var isViewed = false
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case urlString = "html_url"
  }
  
//  override static func primaryKey() -> String? {
//    return "id"
//  }
  
}

extension Repository {
  
  var url: URL {
    return URL(string: urlString) ?? NSURL() as URL
  }
  
}

func == (lhs: Repository, rhs: Repository) -> Bool {
  return lhs.id == rhs.id
}

import Foundation

struct Page<T: Decodable>: Decodable {
  var index: Int = 1
  var totalCount: Int
  var isIncompleteResults: Bool
  var items: [T]

  private enum CodingKeys: String, CodingKey {
    case totalCount = "total_count"
    case isIncompleteResults = "incomplete_results"
    case items
  }

}

extension Page {

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    totalCount = try container.decode(Int.self, forKey: .totalCount)
    isIncompleteResults = try container.decode(Bool.self, forKey: .isIncompleteResults)
    items = try container.decode([T].self, forKey: .items)
  }
  
}

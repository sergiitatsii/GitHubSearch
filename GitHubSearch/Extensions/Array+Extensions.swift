import Foundation

extension Array where Element: Equatable {
  
  public mutating func appendWithoutDuplicates<C: Collection>(contentsOf: C) where C.Iterator.Element == Element {
    let filteredArray = contentsOf.filter({!self.contains($0)})
    self.append(contentsOf: filteredArray)
  }
  
}

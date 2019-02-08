import Foundation
import RealmSwift
import CoreData

/// Protocol for storable types: Realm -> Object; CoreData -> NSManagedObject.
public protocol Storable {
  
}

extension Object: Storable {}
extension NSManagedObject: Storable {}

public struct Sorted {
  var key: String
  var ascending: Bool = true
}

public protocol StorageCreateProtocol {
  /// Create a new object with default values.
  /// Return an object that is conformed to the `Storable` protocol.
  func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws
  
  /// Save an object that is conformed to the `Storable` protocol.
  func save(object: Storable) throws
}

public protocol StorageReadProtocol {
  /// Return a list of objects that are conformed to the `Storable` protocol.
  func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}

public protocol StorageUpdateProtocol {
  /// Update an object that is conformed to the `Storable` protocol.
  func update(_ block: @escaping () -> ()) throws
}

public protocol StorageDeleteProtocol {
  /// Delete an object that is conformed to the `Storable` protocol.
  func delete(object: Storable) throws
  
  /// Delete all objects that are conformed to the `Storable` protocol.
  func deleteAll<T: Storable>(_ model: T.Type) throws
  
  /// Deletes all objects from the Realm.
  func reset() throws
}

/// # Protocol contains CRUD operations to:
/// * create an empty object
/// * save an object
/// * update an object
/// * delete an object / delete all objects of a certain type
/// * retrieve objects based on the type
public protocol Storage: StorageCreateProtocol, StorageReadProtocol, StorageUpdateProtocol, StorageDeleteProtocol {}

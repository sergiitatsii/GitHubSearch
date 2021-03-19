import Foundation
import RealmSwift

/// Storage configuration options.
public enum ConfigurationType {
  case basic(url: String?)
  case inMemory(identifier: String?)
  
  var associated: String? {
    get {
      switch self {
      case .basic(let url): return url
      case .inMemory(let identifier): return identifier
      }
    }
  }
}

enum RealmStorageError: Error {
  case missingInMemoryIdentifier(description: String)
  case nilVariable(description: String)
}


/// Concrete implementation `Storage` protocol based on Realm.
public class RealmStorage {
  
  private var realm: Realm?
  
  public required init(configuration: ConfigurationType = .basic(url: nil)) throws {
    var rmConfig = Realm.Configuration()
    rmConfig.readOnly = true
    switch configuration {
    case .basic:
      rmConfig = Realm.Configuration.defaultConfiguration
      if let url = configuration.associated {
        rmConfig.fileURL = URL(string: url)
      }
    case .inMemory:
      rmConfig = Realm.Configuration()
      if let identifier = configuration.associated {
        rmConfig.inMemoryIdentifier = identifier
      } else {
        throw RealmStorageError.missingInMemoryIdentifier(description: "Missing a string used to identify a particular in-memory Realm.")
      }
    }
    try realm = Realm(configuration: rmConfig)
  }
  
  public func safeWrite(_ block: (() throws -> Void)) throws {
    guard let realm = self.realm else {
      throw RealmStorageError.nilVariable(description: "Optional variable `realm` is nil")
    }
    
    if realm.isInWriteTransaction {
      try block()
    } else {
      try realm.write(block)
    }
  }
}

extension RealmStorage: Storage {
  
  public func create<T: Storable>(_ model: T.Type, completion: @escaping ((T) -> Void)) throws {
    try safeWrite {
        let newObject = realm?.create(model as! Object.Type, value: [], update: .error) as! T
      completion(newObject)
    }
  }
  
  public func save(object: Storable) throws {
    try safeWrite {
      realm?.add(object as! Object)
    }
  }
  
  public func update(_ block: @escaping () -> Void) throws {
    try safeWrite {
      block()
    }
  }
  
  public func delete(object: Storable) throws {
    try safeWrite {
      realm?.delete(object as! Object)
    }
  }
  
  public func deleteAll<T : Storable>(_ model: T.Type) throws {
    guard let realm = self.realm else {
      throw RealmStorageError.nilVariable(description: "Optional variable `realm` = nil")
    }
    
    try safeWrite {
      let objects = realm.objects(model as! Object.Type)
      
      for object in objects {
        realm.delete(object)
      }
    }
  }
  
  public func reset() throws {
    try safeWrite {
      realm?.deleteAll()
    }
  }
  
  public func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted? = nil, completion: (([T]) -> ())) {
    guard let realm = self.realm else {
      completion([])
      return
    }
    
    var objects = realm.objects(model as! Object.Type)
    
    if let predicate = predicate {
      objects = objects.filter(predicate)
    }
    
    if let sorted = sorted {
      objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
    }
    
    completion(objects.compactMap { $0 as? T })
  }
  
}

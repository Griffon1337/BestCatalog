
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "diplom_project")
        container.loadPersistentStores {
            storeDescription, error in
        }
        return container
    }()
    
    func save(completion: (Error?) -> ()) {
        guard context.hasChanges else {
            completion(CoreDataManagerError.noData)
            return
        }
        do {
            try context.save()
            completion(nil)
        }
        catch {
            completion(error)
        }
    }
    
    enum CoreDataManagerError: Error {
        case noData
    }
}



import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {} // Ensure no external instantiation
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieData")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveMoviesToCoreData(_ movies: [Movie]) {
        let context = persistentContainer.viewContext
        for movieData in movies {
            let movieEntity = MovieEntity(context: context)
            movieEntity.configure(with: movieData)
        }
        saveContext()
    }
}

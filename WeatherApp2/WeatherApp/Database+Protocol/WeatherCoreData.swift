//
//  WeatherCoreData.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//

import CoreData

class WeatherCoreDataDelegate: WeatherProtocol {
    //var modelName From Protocol
    var modelName: String
    var managedObjectContext: NSManagedObjectContext

    init(modelName: String) {
        let persistentCoordinator: NSPersistentStoreCoordinator = {
                
            let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
            let persistentCoordinator = NSPersistentStoreCoordinator(managedObjectModel:
                                                    managedObjectModel!)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                    .userDomainMask, true)[0]
            let storeURL = URL(fileURLWithPath: documentsPath.appending("/\(modelName).sqlite"))
            print("storeUrl = \(storeURL)")
            do {
                try persistentCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                     configurationName: nil,
                                                     at: storeURL,
                                                     options: [NSSQLitePragmasOption:
                                                                  ["journal_mode":"MEMORY"]])
                return persistentCoordinator
            } catch {
                abort()
            }
        } ()
        
        self.modelName = modelName
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = persistentCoordinator
   }
        
    //func saveContext From Protocol
    func saveContext(managedObjectContext: NSManagedObjectContext) {
        guard managedObjectContext.hasChanges else { return }
        managedObjectContext.performAndWait(){
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Database save unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
}

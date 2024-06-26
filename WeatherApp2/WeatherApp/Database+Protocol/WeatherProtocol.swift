//
//  WeatherProtocol.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//

import CoreData

protocol WeatherProtocol {
    
    var modelName: String { get }
    var managedObjectContext: NSManagedObjectContext { get }
    
    func saveContext(managedObjectContext: NSManagedObjectContext)
}

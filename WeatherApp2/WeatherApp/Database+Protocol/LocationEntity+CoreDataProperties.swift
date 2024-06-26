//
//  LocationEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData


extension LocationEntity{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var country: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var tzId: String?
    @NSManaged public var localtimeEpoch: Double
    @NSManaged public var localtime: String?
    
}

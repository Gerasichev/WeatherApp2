//
//  WeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData

extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var toCurrent: CurrentEntity?
    @NSManaged public var toLocation: LocationEntity?

}

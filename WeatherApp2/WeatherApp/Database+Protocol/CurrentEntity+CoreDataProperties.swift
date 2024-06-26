//
//  CurrentEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData


extension CurrentEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentEntity> {
        return NSFetchRequest<CurrentEntity>(entityName: "CurrentEntity")
    }

    @NSManaged public var tempC: Double
    @NSManaged public var tempF: Double
    @NSManaged public var windKph: Double
    @NSManaged public var windMph: Double
    @NSManaged public var humidity: Double
    @NSManaged public var feelslikeC: Double
    @NSManaged public var feelslikeF: Double
    @NSManaged public var toCondition: ConditionEntity?
}

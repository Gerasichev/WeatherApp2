//
//  ConditionEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData


extension ConditionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConditionEntity> {
        return NSFetchRequest<ConditionEntity>(entityName: "ConditionEntity")
    }

    @NSManaged public var text: String?
    @NSManaged public var icon: String?
}

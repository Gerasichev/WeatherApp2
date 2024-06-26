//
//  ConditionEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData

@objc(ConditionEntity)
public class ConditionEntity: NSManagedObject {
    
    var condition: Condition{
        get{
            return self.condition
        }
        set(newValue){
            text = newValue.text
            icon = newValue.icon
        }
    }

}

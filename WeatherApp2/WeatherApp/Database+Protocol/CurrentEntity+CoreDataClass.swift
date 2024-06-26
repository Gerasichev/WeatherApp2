//
//  CurrentEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData

@objc(CurrentEntity)
public class CurrentEntity: NSManagedObject {
    
    var current: Current {
        get{
            return self.current
        }
        set(newValue) {
            tempC = newValue.tempC
            tempF = newValue.tempC
            windKph = newValue.windKph
            windMph = newValue.windMph
            humidity = Double(newValue.humidity)
            feelslikeC = newValue.feelslikeC
            feelslikeF = newValue.feelslikeF
        }
    }
}

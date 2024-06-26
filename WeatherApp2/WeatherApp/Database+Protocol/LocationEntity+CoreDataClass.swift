//
//  LocationEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Герасичев Сергей on 22.06.2024.
//
//

import Foundation
import CoreData

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {
    
    var location: Location {
        get {
            return self.location
        }
        set(newValue) {
            name = newValue.name
            region = newValue.region
            lat = newValue.lat
            lon = newValue.lon
            tzId = newValue.tzId
            localtimeEpoch = Double(newValue.localtimeEpoch)
            localtime = newValue.localtime
        }
    }

}

//
//  Coord.swift
//  WeatherForecast
//
//  Created by sophia on 20/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation
public struct Coord: CustomStringConvertible
{
    public var lat: Double
    public var lon: Double
    
    public init?(data: NSDictionary!) {
        if let lat = data?.valueForKeyPath("lat") as? Double{
            self.lat = lat
            if let lon = data?.valueForKeyPath("lon") as? Double{
                self.lon = lon
                return
            }
        }
        lat = 0
        lon = 0
        return nil
    }
    public var description: String {
        return "city.coord.lat = \(lat),city.coord.lon =\(lon)"
    }
    
}

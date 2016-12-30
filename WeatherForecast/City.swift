//
//  City.swift
//  WeatherForecast
//
//  Created by sophia on 19/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation
import CoreLocation

public struct City: CustomStringConvertible
{
    public var country: String = ""
    public var id: Int = 0
    public var name: String = ""
    public var population: Int = 0
    public var coord: Coord
    
    public var description: String {
        return "city.country= \(country),city.id =\(id),city.name =\(name),city.population =\(population),city.coord =\(coord)"
    }
    
    init?(data: NSDictionary?) {
        if let country = data?.valueForKeyPath("country") as? String{
            self.country = country
            if let id = data?.valueForKeyPath("id") as? Int{
                self.id = id
                if let name = data?.valueForKeyPath("name") as? String{
                    self.name = name
                    if let population = data?.valueForKeyPath("population") as? Int{
                        self.population = population
                        if let coord = Coord(data: data?.valueForKeyPath("coord") as! NSDictionary) {
                            self.coord = coord
                            return
                        }
                    }
                }
            }
        }
        self.country = ""
        self.id = 0
        self.name = ""
        self.population = 0
        return nil
    }
}
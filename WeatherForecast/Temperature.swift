//
//  Temperature.swift
//  WeatherForecast
//
//  Created by sophia on 20/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation
public struct Temperature: CustomStringConvertible
{
    public var day: Int
    public var eve: Int
    public var max: Int
    public var min: Int
    public var morn: Int
    public var night: Int
    
    init?(data: NSDictionary?) {
        if let day = data?.valueForKeyPath("day") as? Int {
            self.day = day
            if let eve = data?.valueForKeyPath("eve") as? Int {
                self.eve = eve
                if let max = data?.valueForKeyPath("max") as? Int {
                    self.max = max
                    if let min = data?.valueForKeyPath("min") as? Int {
                        self.min = min
                        if let morn = data?.valueForKeyPath("morn") as? Int {
                            self.morn = morn
                            if let night = data?.valueForKeyPath("night") as? Int {
                                self.night = night
                                return
                            }
                        }
                    }
                }
            }
        }
        self.day = 0
        self.eve = 0
        self.max = 0
        self.min = 0
        self.morn = 0
        self.night = 0
        return nil
    }
    
    
    public var description: String {
        return "temp.day=\(day),temp.eve=\(eve),temp.max=\(max),temp.min=\(min),temp.morn=\(morn),temp.night=\(night)"
    }
}

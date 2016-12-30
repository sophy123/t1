//
//  WeatherItem.swift
//  WeatherForecast
//
//  Created by sophia on 20/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation

public struct WeatherItem: CustomStringConvertible
{
    public var weatherDescription: String
    public var icon: String
    public var iconUrl: NSURL?
    public var id: Int
    public var main: String
    
    private let iconBaseUrl = "http://openweathermap.org/img/w/"
    
    init?(data: NSDictionary?) {
        if let weatherDescription = data?.valueForKeyPath("description") as? String {
            self.weatherDescription = weatherDescription
            if let icon = data?.valueForKeyPath("icon") as? String {
                self.icon = icon
                self.iconUrl = NSURL(string: iconBaseUrl + icon + ".png")!
                if let id = data?.valueForKeyPath("id") as? Int {
                    self.id = id
                    if let main = data?.valueForKeyPath("main") as? String {
                        self.main = main
                        return
                    }
                }
            }
        }
        self.weatherDescription = ""
        self.icon = ""
        self.id = 0
        self.main = ""
        return nil
    }
    public var description: String {
        return "weather.description=\(weatherDescription),weather.icon=\(icon),weather.id=\(id),weather.main=\(main)"
    }
    
}


//
//  Day.swift
//  WeatherForecast
//
//  Created by sophia on 19/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation
import CoreLocation

public struct Day: CustomStringConvertible
{
    
        public var clouds: Int = 0
        public var deg: Int = 0
        public var dt: String = ""
        public var humidity: Int = 0
        public var pressure: Double = 0
        public var speed: Double = 0
        public var snow: Double?
        public var rain: Double?
        public var weather = [WeatherItem]()
        public var temp: Temperature
    
        public var description: String {
            return "clouds=\(clouds),deg=\(deg),dt=\(dt),humidity=\(humidity),pressure=\(pressure),speed=\(speed),snow =" + (snow == nil ? "nil" : "\(snow)") + "rain =" + (rain == nil ? "nil" : "\(rain)") + "temp =\(temp)"
        }
    
        init?(data: NSDictionary?)
        {
            if let snow = data?.value(forKeyPath: "snow") as? Double{
                self.snow = snow
            }
            if let rain = data?.value(forKeyPath: "rain") as? Double{
                self.rain = rain
            }
            if let temp = Temperature(data: data?.value(forKeyPath: "temp") as? NSDictionary) {
                self.temp = temp
                if let clouds = data?.value(forKeyPath: "clouds") as? Int {
                    self.clouds = clouds
                    if let deg = data?.value(forKeyPath: "deg") as? Int {
                        self.deg = deg
                        if let dt = data?.value(forKeyPath: "dt") as? Int {
                            self.dt = timeStampToString(dt)
                            if let humidity = data?.value(forKeyPath: "humidity") as? Int {
                                self.humidity = humidity
                                if let pressure = data?.value(forKeyPath: "pressure") as? Double {
                                    self.pressure = pressure
                                    if let speed = data?.value(forKeyPath: "speed") as? Double {
                                        self.speed = speed
                                        if let weatherItems = data?.value(forKeyPath: "weather") as? NSArray {
                                            for weatherData in weatherItems{
                                                if let weatherItem = WeatherItem(data: weatherData as? NSDictionary){
                                                    weather.append(weatherItem)
                                                    return
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.clouds = 0
            self.deg = 0
            self.dt = ""
            self.humidity = 0
            self.pressure = 0
            self.speed = 0
            return nil
        }
    
    public func timeStampToString(_ timeStamp: Int)->String {
        let timeSta:TimeInterval = Double(timeStamp)
        let outputFormat = DateFormatter()
        outputFormat.dateFormat = "dd/MM EEE"
        let date = Date(timeIntervalSince1970: timeSta)
        return outputFormat.string(from: date)
    }
}

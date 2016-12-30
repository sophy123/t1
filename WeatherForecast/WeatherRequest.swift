//
//  WeatherRequest.swift
//  WeatherForecast
//
//  Created by sophia on 19/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation
import CoreLocation

public class WeatherRequest: NSObject
{
 
    public override init(){
        super.init()
    }
    public func fetchWeather(path: NSURL, completionHandler :(ReceivedItem?) -> Void) {
        fetch(path){
            results in
            var myResults: ReceivedItem?
            var dayArray: NSArray?
            var days = [Day]()
            var mycity: City!
            var mycnt: Int = 0
            var mycod: String = ""
            if let dictionary = results as? NSDictionary{
                if let cod = dictionary["cod"] as? String {
                    mycod = cod
                    if let cityData = dictionary["city"] as? NSDictionary {
                        mycity = City(data:cityData as? NSDictionary)
                        if let cnt = dictionary["cnt"] as? Int {
                            mycnt = cnt
                            if let list = dictionary["list"] as? NSArray{
                                dayArray = list
                                for dayData in dayArray!{
                                    if let day = Day(data: dayData as? NSDictionary){
                                        days.append(day)
                                    }
                                }
                            }
                        }
                    }
                }
                myResults = ReceivedItem(city: mycity, days: days, count: mycnt, cod: mycod)
            }
            completionHandler(myResults == nil ? nil : myResults)
        }
    }
    
    public func fetch(path: NSURL,completionHandler: (results: AnyObject?) -> Void){
        performWeatherRequest(path, completionHandler: completionHandler)
    }
    
    func performWeatherRequest(path: NSURL,completionHandler: (AnyObject?) -> Void){
       // var path = NSURL(string: "\(baseUrl)lat=\(latitude)&lon=\(longitude)&cnt=\(count)&mode=json&units=metric&appid=1a56caf11aa6467b6d876eeea0c4e548")!
        sendWeatherRequest(path, completionHandler: completionHandler)
    }
    
    func  sendWeatherRequest(path: NSURL, completionHandler: (AnyObject?) -> Void){
        let request = NSMutableURLRequest(URL: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (jsonResponse, httpResponse, myError) in
            var propertyListResponse :AnyObject?
            if jsonResponse != nil {
                propertyListResponse = try? NSJSONSerialization.JSONObjectWithData(
                    jsonResponse!,
                    options: NSJSONReadingOptions.MutableLeaves
                )
                if propertyListResponse == nil {
                    let error = "Couldn't parse JSON response."
                    print("performWeatherRequest:\(error)")
                    propertyListResponse = error
                }
            }else{
                let error = "No response from openweathermap."
                print("performWeatherRequest:\(error)")
                propertyListResponse = error
            }
            completionHandler(propertyListResponse)
        }
        task.resume()
    }
    
    
}
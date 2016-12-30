//
//  WeatherRequest.swift
//  WeatherForecast
//
//  Created by sophia on 19/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation
import CoreLocation

open class WeatherRequest: NSObject
{
 
    public override init(){
        super.init()
    }
    open func fetchWeather(_ path: URL, completionHandler :@escaping (ReceivedItem?) -> Void) {
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
    
    open func fetch(_ path: URL,completionHandler: @escaping (_ results: AnyObject?) -> Void){
        performWeatherRequest(path, completionHandler: completionHandler)
    }
    
    func performWeatherRequest(_ path: URL,completionHandler: @escaping (AnyObject?) -> Void){
       // var path = NSURL(string: "\(baseUrl)lat=\(latitude)&lon=\(longitude)&cnt=\(count)&mode=json&units=metric&appid=1a56caf11aa6467b6d876eeea0c4e548")!
        sendWeatherRequest(path, completionHandler: completionHandler)
    }
    
    func  sendWeatherRequest(_ path: URL, completionHandler: @escaping (AnyObject?) -> Void){
        let request = NSMutableURLRequest(url: path)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (jsonResponse, httpResponse, myError) in
            var propertyListResponse :AnyObject?
            if jsonResponse != nil {
                propertyListResponse = try? JSONSerialization.jsonObject(
                    with: jsonResponse!,
                    options: JSONSerialization.ReadingOptions.mutableLeaves
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
        }) 
        task.resume()
    }
    
    
}

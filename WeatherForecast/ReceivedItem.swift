//
//  ReceivedItem.swift
//  WeatherForecast
//
//  Created by sophia on 20/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import Foundation

public struct ReceivedItem: CustomStringConvertible
{
    public var city: City
    public var days = [Day]()
    public var count: Int
    public var cod: String!
    
    init?(city: City, days: [Day], count: Int, cod: String){
        self.city = city
        self.days = days
        self.count = count
        self.cod = cod
    }
    public var description: String{
        return "city =" + "\(city)" + "days =\(days)" + "count =\(count)" + "cod ="+(cod == nil ? "nil" : "\(cod)")
    }
    
    
}

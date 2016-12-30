//
//  CustomTableViewCell.swift
//  WeatherForecast
//
//  Created by sophia on 20/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var day: Day?{
        didSet{
            updateUI()
        }
    }
    internal let celsiusSymbol = "℃"

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var shortWeatherDescription: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var highAndLowTemp: UILabel!
    func updateUI(){
        weatherImageView?.image = nil
        dataLabel?.text = nil
        shortWeatherDescription?.text = nil
        dayTempLabel?.text = nil
        highAndLowTemp?.text = nil
        
        if let day = self.day {
            if let dt: String = day.dt {
                dataLabel.text = dt
            }
            if let main: String = day.weather[0].main {
                shortWeatherDescription.text = main
            }
            if let dayTemp: Int = day.temp.day {
                dayTempLabel.text = "\(dayTemp)"+"\(celsiusSymbol)"
            }
            var str: String = ""
            if let highTemp: Int = day.temp.max {
                str+="\(highTemp)"+celsiusSymbol
                if let lowTemp: Int = day.temp.min {
                    str+=" / "+"\(lowTemp)"+celsiusSymbol+","
                    
                }
            }
            if let pressure: Double = day.pressure {
                str+=" Pressure: "+"\(pressure)"+" hPa,"
            }
            if let humidity: Int = day.humidity {
                str+=" Humidity: "+"\(humidity)"+"%,"
            }
            if let speed: Double = day.speed {
                str+=" Wind Speed: "+"\(speed)"+" meter/sec,"
            }
            if let cloud: Int = day.clouds {
                str+=" Cloudiness: "+"\(cloud)"+"%,"
            }
            if let deg: Int = day.deg {
                str+=" Wind Direction: "+"\(deg)"+" degrees"
            }
            highAndLowTemp.text = str
            
            if let profileImageUrl = day.weather[0].iconUrl{
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                dispatch_async(dispatch_get_global_queue(qos, 0)){() -> Void in
                    if let imageData = NSData(contentsOfURL: profileImageUrl){
                        dispatch_async(dispatch_get_main_queue()){ () -> Void in
                            self.weatherImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }

            
        }
    }
}

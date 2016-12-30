//
//  CurrentWeatherViewController.swift
//  WeatherForecast
//
//  Created by sophia on 20/01/2016.
//  Copyright © 2016 sophia. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController, CLLocationManagerDelegate
{
   
    @IBOutlet weak var myButton: UIButton!{
        didSet{
            myButton.isEnabled = false
        }
    }
    var today: Day!
    var todayWeather: WeatherItem!
    var receivedData: ReceivedItem!{
        didSet{
            today = self.receivedData.days[0]
            todayWeather = today.weather[0]
            myButton?.isEnabled = true
            updateCurrentUI()
        }
    }
    
    internal var latitude: CLLocationDegrees! = 52
    internal var longitude: CLLocationDegrees! = -0.13
    
    var locationManager = CLLocationManager()
    
    
    var myLocation: CLLocation = CLLocation(latitude: 52, longitude:  -0.13)
        {
        didSet{
            latitude = myLocation.coordinate.latitude
            longitude = myLocation.coordinate.longitude
            print("--set mylocation")
            print("--latitude = \(latitude)")
            print("--longitude = \(longitude)")
            nextSessionToAttempt = WeatherRequest()
            updateData()
        }
    }

    
    internal var count: Int = 16
    let baseUrl = "http://api.openweathermap.org/data/2.5/forecast/daily?"
    var nextSessionToAttempt:WeatherRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        nextSessionToAttempt = WeatherRequest()
        startAnimation()
        spinner.startAnimating()
        updateData()
    }
    func updateCurrentLocation(){
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        print("\(status.rawValue)")
        if (status == .notDetermined) || (status == .restricted) || (status == .denied) {
            print("locationManager status is not allowed, then use default city -- Bygrave")
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        if (status == .authorizedWhenInUse) || (status == .authorizedAlways)
        {
            print("locationManager status is allowed")
            setLocationManager()
        }
    }
    
    internal func setLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print("settng locationManager")
    }
    internal func locationManager (_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.authorizedWhenInUse) || (status == CLAuthorizationStatus.authorizedAlways){
            print("locationManager did Change AuthorizationStatus To Be allowed")
        }
        
    }
   
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailwithError:\(error)")
    }
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        myLocation = locations.last! as CLLocation
        print("locationManager didupdateLocation:\(myLocation)")
    }

    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var shortWeatherDescription: UILabel!
    @IBOutlet weak var highAndLowTemp: UILabel!
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    fileprivate func updateData(){
        let path = URL(string: "\(baseUrl)lat=\(latitude)&lon=\(longitude)&cnt=\(count)&mode=json&units=metric&appid=1a56caf11aa6467b6d876eeea0c4e548")!
        nextSessionToAttempt.fetchWeather(path)
        {(newWeather) -> Void in
            DispatchQueue.main.async{ () -> Void in
                if newWeather != nil {
                    if newWeather!.count > 0 {
                        self.receivedData = newWeather
                    }
                }else{
                    print("no data")
                    self.myButton?.isEnabled = false
                    self.spinner.stopAnimating()
                    self.popAlert()
                }
            }
        }
    }
    internal func popAlert(){
        let alert = UIAlertController(title: "Error", message: "Ops! It seems that the internet doesn't work", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: {action in
            self.spinner.startAnimating()
            self.updateCurrentLocation()
            self.nextSessionToAttempt = WeatherRequest()
            self.updateData()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func updateCurrentUI(){
        updateWeatherImageView()
        updateTemperature()
        title = receivedData.city.name+", "+receivedData.city.country
        spinner.stopAnimating()
    }
    
    fileprivate func updateWeatherImageView(){
        if let profileImageUrl = todayWeather.iconUrl{
            let qos = Int(DispatchQoS.QoSClass.userInitiated.rawValue)
            DispatchQueue.global(priority: qos).async{() -> Void in
                if let imageData = try? Data(contentsOf: profileImageUrl){
                    DispatchQueue.main.async{ () -> Void in
                        self.weatherImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }

    }
    internal func updateTemperature(){
        weatherImageView?.image = nil
        shortWeatherDescription?.text = nil
        highAndLowTemp?.text = nil
        dayTemp?.text = nil
        
        if let today = self.today{
            if let shortWeatherDescriptionText: String = todayWeather.main {
                shortWeatherDescription.text = shortWeatherDescriptionText
            }
            var temp: String = ""
            if let todayHighTemp: Int = today.temp.max {
                temp = "\(todayHighTemp)"+"℃"
                if let todayLowTemp: Int = today.temp.min {
                    temp+="/"+"\(todayLowTemp)"+"℃,"
                    
                }
            }
            if let pressure: Double  = today.pressure {
                temp+=" Pressure: "+"\(pressure)"+" hPa,"
            }
            if let humidity: Int = today.humidity {
                temp+=" Humidity: "+"\(humidity)"+"%,"
            }
            if let speed: Double = today.speed {
                temp+=" Wind Speed: "+"\(speed)"+" meter/sec,"
            }
            if let cloud: Int = today.clouds {
                temp+=" Cloudiness: "+"\(cloud)"+"%,"
            }
            if let deg: Int = today.deg {
                temp+=" Wind Direction: "+"\(deg)"+" degrees"
            }
            highAndLowTemp.text = temp
            if let todayTemp: Int = today.temp.day {
                dayTemp.text = "\(todayTemp)"+"℃"
            }
        }
        
            
    }
    fileprivate func startAnimation(){
        var images: [UIImage] = []
        for i in 1...2 {
            images.append(UIImage(named: "win_\(i)")!)
        }
        myImageView.animationImages = images
        myImageView.animationDuration = 1.0
        myImageView.startAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination: UIViewController = segue.destination
       
        if let lvc = destination as? ListTableViewController{
            if let identifier = segue.identifier{
                if identifier == "seeMoreDaysSegue" {
                    lvc.receivedObject = self.receivedData
                    let backItem = UIBarButtonItem()
                    backItem.title = "Today"
                    navigationItem.backBarButtonItem = backItem
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

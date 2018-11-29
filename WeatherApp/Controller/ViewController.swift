//
//  ViewController.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/7/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let API_KEY: String = "780026e2fb6e47d4b28201449182611"
    let API_URL: String = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    var forecastArray = [ForecastWeatherData]()
    

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        searchBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // If user tapped outside the search bar, hide it
        backgroundImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOutsideSearchBar))
        backgroundImage.addGestureRecognizer(tapGesture)
    }
    
    // Get data from url
    //****************************************************************************//
    func getWeatherData(url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print(response)
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print(response.result.error!)
                self.cityLabel.text = "Connection issues"
            }
        }
    }
    
      /*Daily forecast API available only for subscribers of openweathermap.org*/
    
//    func getForecastWeatherData(url: String, parameters: [String:String]) {
//        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
//            response in
//            let result = response.result
//            if let dictionary = result.value as? Dictionary<String, AnyObject> {
//                if let list = dictionary["list"] as? [Dictionary<String, AnyObject>] {
//                    for item in list[1...3] {
//                        let forecast = ForecastWeatherData(weatherData: item)
//                        self.forecastArray.append(forecast)
//                    }
//                    self.collectionView.reloadData()
//                }
//            }
//        }
//
//    }
    
    //JSON Parsing
    //****************************************************************************//
    func updateWeatherData(json: JSON) {
        
            weatherDataModel.temparature = json["data"]["current_condition"][0]["temp_C"].intValue
            weatherDataModel.city = json["data"]["nearest_area"][0]["areaName"][0]["value"].stringValue
            weatherDataModel.date = weatherDataModel.dateConvertor(date: json["data"]["weather"][0]["date"].stringValue) 
            weatherDataModel.weatherCode = json["data"]["current_condition"][0]["weatherCode"].intValue
            print(weatherDataModel.weatherCode)
            weatherDataModel.weatherType = json["data"]["current_condition"][0]["weatherDesc"][0]["value"].stringValue
            weatherDataModel.weatherIcon = weatherDataModel.updateWeatherIcon(weatherCode: weatherDataModel.weatherCode)
            
            updateWeatherUI()
        
            //cityLabel.text = "Weather unvailable"
    }
    
    
    //Update UI
    //****************************************************************************//
    func updateWeatherUI() {
        cityLabel.text = weatherDataModel.city
        dateLabel.text = weatherDataModel.date
        weatherImage.image = UIImage(named: weatherDataModel.weatherIcon)
        temperatureLabel.text = String(weatherDataModel.temparature) + "°"
        weatherTypeLabel.text = weatherDataModel.weatherType
    }
    
    //LocationManager Setup
    //****************************************************************************//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(currentLocation.coordinate.latitude)
            let longitude = String(currentLocation.coordinate.longitude)
            
            let weatherParams: [String:String] = ["key": API_KEY, "lat": latitude, "lon": longitude, "format": "json", "num_of_days": "3", "includelocation": "yes"]
            getWeatherData(url: API_URL, parameters: weatherParams)
            
            //let forecastParams: [String:String] = ["lat": latitude, "lon": longitude, "cnt": "\(3)", "appid": API_KEY]
            //getForecastWeatherData(url: FORECAST_URL, parameters: forecastParams)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location is unavailable"
        print(error)
    }
    


    // SearchBar settings
    //*****************************************************************//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            let newParameters: [String:String] = ["key": API_KEY, "q": searchBar.text!, "format": "json", "num_of_days": "3", "includelocation": "yes"]
            getWeatherData(url: API_URL, parameters: newParameters)
        }
        searchBar.endEditing(true)
        searchBar.isHidden = true
        searchBar.text = ""
        searchButton.isHidden = false
        
    }

    @IBAction func searchButtonPressed(_ sender: Any) {
        searchBar.keyboardType = .alphabet
        searchButton.isHidden = true
        searchBar.isHidden = false
        
    }
    
    @objc func tappedOutsideSearchBar() {
        if searchBar.isHidden == false {
            searchBar.endEditing(true)
            searchBar.isHidden = true
            searchBar.text = ""
            searchButton.isHidden = false
        }
        
    }
    
    
    // CollectionVIew settings for showing daily forecast
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! CollectionViewCell

        cell.configureCell(forecastWeather: forecastArray[indexPath.row])

        return cell

    }
    
}

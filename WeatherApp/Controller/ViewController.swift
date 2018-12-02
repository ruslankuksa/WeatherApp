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
                
                self.updateWeatherUI(weatherData: WeatherDataModel(json: weatherJSON))
                self.updateForecastUI(weatherJSON: weatherJSON)
                
            }
            else {
                print(response.result.error!)
                self.cityLabel.text = "Connection issues"
            }
        }
    }
    
    //Update UI
    //****************************************************************************//
    func updateWeatherUI(weatherData: WeatherDataModel) {
        cityLabel.text = weatherData.city
        dateLabel.text = weatherData.date
        temperatureLabel.text = String(weatherData.temperature) + "°"
        weatherTypeLabel.text = weatherData.weatherType
        weatherImage.image = UIImage(named: weatherData.weatherIcon)
        
    }
    
    func updateForecastUI(weatherJSON: JSON) {
        forecastArray.removeAll()
        for item in weatherJSON["data"]["weather"].arrayValue {
            let forecast = ForecastWeatherData(json: item)
            forecastArray.append(forecast)
        }
        
        if !(forecastArray.isEmpty) {
            forecastArray.remove(at: 0)
        }
        
        collectionView.reloadData()
        
        
        
    }
    
    //LocationManager Setup
    //****************************************************************************//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        if currentLocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = String(currentLocation.coordinate.latitude)
            let longitude = String(currentLocation.coordinate.longitude)
            
            let weatherParams: [String:String] = ["key": API_KEY, "lat": latitude, "lon": longitude, "format": "json", "num_of_days": "4", "includelocation": "yes"]
            getWeatherData(url: API_URL, parameters: weatherParams)
            
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
            let newParameters: [String:String] = ["key": API_KEY, "q": searchBar.text!, "format": "json", "num_of_days": "4", "includelocation": "yes"]
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
        cell.sizeToFit()

        return cell

    }
    
}

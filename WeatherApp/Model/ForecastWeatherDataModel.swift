//
//  ForecastWeatherDataModel.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/20/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import Foundation

class ForecastWeatherData {
    var date: String = ""
    var temp: Int = 0
    var weatherIcon: String = ""
    var weatherType: String = ""
    
    init(weatherData: [String : AnyObject]) {
        if let dayTemp = weatherData["temp"]?["day"] as? Double{
            self.temp = Int(dayTemp - 273.15)
        }
        
        if let numberOfDay = weatherData["dt"] as? Double {
            
            let takenDate = Date(timeIntervalSince1970: numberOfDay)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            let currentDate = dateFormatter.string(from: takenDate)
           
            self.date = currentDate
        }
        
        let array: Array<Dictionary<String, AnyObject>> = weatherData["weather"] as! Array
        for item in array {
            self.weatherType = item["main"] as! String
        }
        
    }
    
//    func updateWeatherIcon(condition: Int) -> String {
//        switch condition {
//
//        case 0...300:
//            return "009-storm-1"
//
//        case 301...500:
//            return "003-rainy"
//
//        case 501...600:
//            return "004-rainy-1"
//
//        case 601...700:
//            return "006-snowy"
//
//        case 701...771:
//            return "017-foog"
//
//        case 772...799:
//            return "008-storm"
//
//        case 800:
//            return "039-sun"
//
//        case 801...804:
//            return "011-cloudy"
//
//        case 900...903, 905...1000:
//            return "008-storm"
//
//        case 903:
//            return "006-snowy"
//
//        case 904:
//            return "039-sun"
//
//        default:
//            return "014-compass"
//        }
//    }
}

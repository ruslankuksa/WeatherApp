//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/10/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import Foundation

class WeatherDataModel {
    var temparature: Int = 0
    var weatherCode: Int = 0
    var weatherType: String = ""
    var city: String = ""
    var date: String = ""
    var weatherIcon: String = ""
    
    func updateWeatherIcon(weatherCode: Int) -> String {
        switch weatherCode {
        
        case 0...300:
            return "009-storm-1"
        
        case 301...500:
            return "003-rainy"
            
        case 501...600:
            return "004-rainy-1"
            
        case 601...700:
            return "006-snowy"
            
        case 701...771:
            return "017-foog"
            
        case 772...799:
            return "008-storm"
            
        case 800:
            return "039-sun"
            
        case 801...804:
            return "011-cloudy"
            
        case 900...903, 905...1000:
            return "008-storm"
            
        case 903:
            return "006-snowy"
            
        case 904:
            return "039-sun"
            
        default:
            return "014-compass"
        }
    }
    
    //Other functions
    //****************************************************************************//
    func dateConvertor(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let formattedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd MMM, yyy"
            return dateFormatter.string(from: formattedDate)
        }
        
        return date
        
    }
}

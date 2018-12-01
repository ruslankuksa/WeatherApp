//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/10/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherDataModel {
    var temparature: Int = 0
    var weatherCode: Int = 0
    var weatherType: String = ""
    var city: String = ""
    var date: String = ""
    var weatherIcon: String = ""
    
    init(json: JSON) {
        self.temparature = json["data"]["current_condition"][0]["temp_C"].intValue
        self.city = json["data"]["nearest_area"][0]["areaName"][0]["value"].stringValue
        self.date = dateConvertor(date: json["data"]["weather"][0]["date"].stringValue)
        
        self.weatherCode = json["data"]["current_condition"][0]["weatherCode"].intValue
        print(weatherCode)
        
        self.weatherType = json["data"]["current_condition"][0]["weatherDesc"][0]["value"].stringValue
        self.weatherIcon = updateWeatherIcon(weatherCode: weatherCode)
        
        //cityLabel.text = "Weather unvailable"
    }
    
    func updateWeatherIcon(weatherCode: Int) -> String {
        switch weatherCode {
        
        case 113: return "039-sun"
            
        case 116: return "038-cloudy-3"
            
        case 119: return "001-cloud"
            
        case 122: return "011-cloudy"
            
        case 143: return "017-foog"
            
        case 176, 263, 353: return "034-cloudy-1"
            
        case 179: return "004-rainy-1"
            
        case 182, 227, 230, 311, 314, 317, 320, 329, 332, 335, 338, 350, 371: return "006-snowy"
            
        case 185, 281, 284: return "035-snowy-2"
            
        case 200, 386, 389: return "013-storm-2"
            
        case 248, 260: return "017-foog"
            
        case 266, 293, 296: return "003-rainy"
        
        case 299, 302, 305, 308, 356, 359, 362, 365: return "004-rainy-1"
            
        case 323, 326, 368: return "035-snowy-2"
            
        case 374, 377: return "012-snowy-1"
            
        case 392, 395: return "008-storm"
        
        default: return "014-compass"
        }
    }
    
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

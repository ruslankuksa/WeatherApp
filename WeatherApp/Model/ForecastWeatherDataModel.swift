//
//  ForecastWeatherDataModel.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/20/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForecastWeatherData: WeatherDataModel {
    
    override init(json: JSON) {
        super.init(json: json)
        date = dateConvertor(date: json["date"].stringValue)
        temperature = json["hourly"][4]["tempC"].intValue
        weatherType = json["hourly"][4]["weatherDesc"][0]["value"].stringValue
        weatherCode = json["hourly"][4]["weatherCode"].intValue
        weatherIcon = updateWeatherIcon(weatherCode: weatherCode)
    }
    
    
    override func dateConvertor(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let formattedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: formattedDate)
        }
        
        return date
        
    }


}

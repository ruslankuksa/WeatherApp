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
    
    init(data: JSON) {
        super.init(json: data)
        date = dateConvertor(date: data["date"].stringValue)
        temperature = data["hourly"][4]["tempC"].intValue
        weatherType = data["hourly"][4]["weatherDesc"][0]["value"].stringValue
        weatherCode = data["hourly"][4]["weatherCode"].intValue
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

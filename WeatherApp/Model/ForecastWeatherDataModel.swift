//
//  ForecastWeatherDataModel.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/20/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForecastWeatherData {
    var date: String = ""
    var temp: Int = 0
    var weatherIcon: String = ""
    var weatherType: String = ""
    
    init(data: Dictionary<String, JSON>) {
        self.date = (data["date"]?.stringValue)!
    }

}

//
//  CollectionViewCell.swift
//  WeatherApp
//
//  Created by Руслан Кукса on 11/20/18.
//  Copyright © 2018 Ruslan Kuksa. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    
    func configureCell(forecastWeather: ForecastWeatherData) {
        self.temperatureLabel.text = String(forecastWeather.temp)
        self.dateLabel.text = forecastWeather.date
        //self.weatherTypeLabel.text = forecastWeather.weatherType
    }

}

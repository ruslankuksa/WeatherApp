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
    
    func configureCell(forecastWeather: ForecastWeatherDataModel) {
        self.temperatureLabel.text = String(forecastWeather.temperature) + "°"
        self.dateLabel.text = forecastWeather.date
        self.weatherTypeLabel.text = forecastWeather.weatherType
        self.weatherImage.image = UIImage(named: forecastWeather.weatherIcon)
    }

}

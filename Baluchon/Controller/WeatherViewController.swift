//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 19/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - properties
    
    private let weather = WeatherService()
    
    // MARK: - IBOutlet & IBActions
    
    @IBOutlet var cityLabels: [UILabel]!
    @IBOutlet var conditionLabels: [UILabel]!
    @IBOutlet var temperatureLabels: [UILabel]!
    @IBOutlet var test: [UIImageView]!
    @IBOutlet weak var imageParis: UIImageView!
    @IBOutlet weak var imageNY: UIImageView!
    
    
    override func viewDidLoad() {
        weather.getWeather() { result in
            switch result {
            case .failure(_):
                self.alert()
            case .success(let weatherData):
                DispatchQueue.main.async {
                    for i in 0..<2 {
                        self.setupUI(cityLabel: self.cityLabels[i], conditionLabel: self.conditionLabels[i], temperatureLabel: self.temperatureLabels[i], weatherData: weatherData.list[i])
                    }
                }
            }
        }
    }
    
    // MARK: -- Méthodes
    func setupUI(cityLabel: UILabel, conditionLabel: UILabel, temperatureLabel: UILabel, weatherData: List) { 
        cityLabel.text = weatherData.name
        conditionLabel.text = weatherData.weather[0].description
        temperatureLabel.text = "\(weatherData.main.temp) °C "
    }
}




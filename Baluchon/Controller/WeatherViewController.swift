//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 19/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let weather = WeatherService()
    
    @IBOutlet var cityLabels: [UILabel]!
    @IBOutlet var conditionLabels: [UILabel]!
    @IBOutlet var temperatureLabels: [UILabel]!
    
    
    func alertVC() {
        let alertVC = UIAlertController(title: "Erreur", message: "Réseau non disponible", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC,animated:true,completion:nil)
    }
    
    override func viewDidLoad() {
        weather.getWeather() { result in
            switch result {
            case .failure(_):
                self.alertVC()
            case .success(let weatherData):
                
                for i in 0..<2 {
                    self.setupUI(cityLabel: self.cityLabels[i], conditionLabel: self.conditionLabels[i], temperatureLabel: self.temperatureLabels[i], weatherData: weatherData.list[i])
                }
            }
        }
    }
    
    func setupUI(cityLabel: UILabel, conditionLabel: UILabel, temperatureLabel: UILabel, weatherData: List) { 
        cityLabel.text = weatherData.name
        conditionLabel.text = weatherData.weather[0].description
        temperatureLabel.text = "\(weatherData.main.temp) °C "
    }
}




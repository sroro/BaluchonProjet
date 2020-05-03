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
    
    @IBOutlet weak var nomVilleLabel: UILabel!
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
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
            case .success(let weatherTest):
                
                
                // aaffiche nom ville
                self.conditionDescriptionLabel.text = weatherTest
                print(weatherTest)
            }
        }
    }
    
    
}




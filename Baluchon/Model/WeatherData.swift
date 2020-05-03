//
//  WeatherData.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 02/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//


import Foundation

// MARK: - Main
struct WeatherData: Decodable {
    
    let temp: [String:Double]
    let weatherDescription: String?
    let country: [String:String]
    
}




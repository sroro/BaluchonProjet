//
//  WeatherData.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 02/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//


import Foundation


struct WeatherData: Decodable {
    
    let weather: [Weather]
    let main: Main
    let name: String
}



// MARK: - Main
struct Main: Decodable {
    let temp: Double
}


// MARK: - Weather
struct Weather: Decodable {
    let  description: String

}




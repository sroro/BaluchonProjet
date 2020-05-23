//
//  WeatherData.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 02/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//


import Foundation

// MARK: - PARIS , NEWYORK
struct WeatherData: Decodable {
    let list: [List]
}

// MARK: - List
struct List: Decodable {
   
    let weather: [Weather]
    let main: Main
    let id: Int
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


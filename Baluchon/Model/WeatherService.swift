//
//  WeatherService.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 02/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//
//2988507  5128581

import Foundation

final class WeatherService {
    
    
    private let session : URLSession
    private var task: URLSessionDataTask?
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }

    enum NetworkError: Error {
        case noData, noResponse, undecodable
    }
    
    ///Récupère conditions météorologique
    func getWeather(callback: @escaping (Result<WeatherData, Error> ) -> Void) {
        guard let weatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/group?id=2988507,5128581&units=metric&appid=8b01aef39585f7ff04d3d616819e17c3&lang=fr") else {return}
        
        task?.cancel()
        task = session.dataTask(with: weatherUrl, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    callback(.failure(NetworkError.noData))
                    return
                }
            
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetworkError.noResponse))
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                    callback(.failure(NetworkError.undecodable))
                    return
                }
                callback(.success(responseJSON))
            }
        })
        task?.resume()
    }
}

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
    
    // MARK: - properties
    
    private let session : URLSession
    private var task: URLSessionDataTask?
    
    // MARK: - initializer
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    // MARK: - Methods
    
    ///Récupère conditions météorologique
    func getWeather(callback: @escaping (Result<WeatherData, Error> ) -> Void) {
        guard let weatherUrl = URL(string: "http://api.openweathermap.org/data/2.5/group?id=2988507,5128581&units=metric&appid=581c10d482e588157559c909970f3f56&lang=fr") else {return}
        
        task?.cancel()
        task = session.dataTask(with: weatherUrl, completionHandler: { (data, response, error) in
                
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
        })
        task?.resume()
    }
}

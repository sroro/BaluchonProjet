//
//  WeatherService.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 02/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

class WeatherService {
    
    
    let session : URLSession
    var task: URLSessionDataTask?
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    
    // enum permet la gestion des differentes erreurs qui est de type Error
    enum NetworkError: Error {
        case noData, noResponse, undecodable
    }
    
    func getWeather( callback: @escaping (Result<String, Error> ) -> Void) {
       guard let weatherUrl = URL(string: "api.openweathermap.org/data/2.5/weather?q=paris&appid=8b01aef39585f7ff04d3d616819e17c3&units=metric&lang=fr") else {return}
        
            
        task?.cancel()
        
        session.dataTask(with: weatherUrl) { (data,response,error) in
            DispatchQueue.main.async {
                
                guard let data = data, error == nil else {
                    callback(.failure(NetworkError.noData))
                    return
                }
                
                // vérifie si le statut code = 200 = OK
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetworkError.noResponse))
                    return
                }
                
                // on décode la réponse reçu en JSON
                 guard let responseJSON = try? JSONDecoder().decode(WeatherData.self, from: data),
                    let weather = responseJSON.weatherDescription else {
                        callback(.failure(NetworkError.undecodable))
                        return
                }
                callback(.success(weather))
                print(weather)
                
            }
        }
        task?.resume()
    }
    
    
    
        
}

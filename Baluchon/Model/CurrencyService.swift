//
//  CurrencyService.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 22/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation
// enum allows the management of different errors which is of type Error
enum NetworkError: Error {
    case noData, noResponse, undecodable
}

final class CurrencyService {
    
    // MARK: - properties
    
    private let session : URLSession
    private var task: URLSessionDataTask?
    
    // MARK: - Initializer
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    // MARK: - Methods
    
    // step 1: creation of the request, currency allows to choose the exchange currency
    func getExchange(devise: String, callback: @escaping (Result<Double, Error>) -> Void) {
        guard  let fixerUrl = URL(string: "https://api.apilayer.com/fixer/latest?apikey=YU6Sbl0O6oDwhV5HZsZGGDlq00ePFh1W&base=USD&symbols=\(devise)")
            else { return }
        
        task?.cancel()
        task = session.dataTask(with: fixerUrl) { (data, response, error) in
            
            // check if data or error = nil else noData
                guard let data = data,error == nil  else {
                    callback(.failure(NetworkError.noData))
                    return
                }
                
                // check if the status code = 200 = OK else noResponse
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetworkError.noResponse))
                    return
                }
                // we decode the response received in JSON else error undecodable
                guard let responseJSON = try? JSONDecoder().decode(FixerData.self, from: data),
                    let currency = responseJSON.rates[devise] else { // responseJSON.rates
                        callback(.failure(NetworkError.undecodable))
                        return
                }
                callback(.success(currency))
            
        }
        task?.resume()
    }
}

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
        guard  let fixerUrl = URL(string: "http://data.fixer.io/api/latest?access_key=892b6eed783bbba6e718701a3e805fe1&symbols=\(devise)") else { return }
        
        task?.cancel()
        task = session.dataTask(with: fixerUrl) { (data, response, error) in
                guard let data = data,error == nil  else {
                    callback(.failure(NetworkError.noData))
                    return
                }
                
                // check if the status code = 200 = OK
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetworkError.noResponse))
                    return
                }
                // we decode the response received in JSON
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

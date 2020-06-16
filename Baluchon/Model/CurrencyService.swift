//
//  CurrencyService.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 22/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

final class CurrencyService {
    
    // MARK: -  appel réseau
    
    private let session : URLSession
    private var task: URLSessionDataTask?
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    // enum permet la gestion des differentes erreurs qui est de type Error
    enum NetworkError: Error {
        case noData, noResponse, undecodable
    }
  
    // etape 1: création de la requête , devise permet de choisir la devise de change
    func getExchange(devise: String, callback: @escaping (Result<Double, Error>) -> Void) {
        guard  let fixerUrl = URL(string: "http://data.fixer.io/api/latest?access_key=892b6eed783bbba6e718701a3e805fe1&symbols=\(devise)") else { return }
        
        task?.cancel()
        task = session.dataTask(with: fixerUrl) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data,error == nil  else {
                    callback(.failure(NetworkError.noData))
                    return
                }
         
                // vérifie si le statut code = 200 = OK
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetworkError.noResponse))
                    return
                }
                // on décode la réponse reçu en JSON
                guard let responseJSON = try? JSONDecoder().decode(FixerData.self, from: data),
                    let currency = responseJSON.rates[devise] else { // responseJSON.rates
                        callback(.failure(NetworkError.undecodable))
                        return
                }
                callback(.success(currency))
            }
        }
        task?.resume()
    }
}

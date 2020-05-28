//
//  TranslateService.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 25/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

class TranslateService {
    
    let session : URLSession
    var task: URLSessionDataTask?
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    enum NetworkError: Error {
        case noData, noResponse, undecodable
    }
    
    func getTranslate(text: String, callback: @escaping (Result<TranslateData, Error> ) -> Void) {
        guard let textEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let translaterUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyAYPTSUKkQREezQHLdzUbTwPiMesKintas&q=\(textEncoded)&source=fr&target=en&format=text") else {return}
        
        task?.cancel()
        task = session.dataTask(with: translaterUrl){(data,response,error) in
            DispatchQueue.main.async {
                guard let data = data,error == nil else {
                    callback(.failure(NetworkError.noData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(NetworkError.noResponse))
                    return
                }
                
                guard let responseJson = try? JSONDecoder().decode(TranslateData.self , from: data) else {
                    callback(.failure(NetworkError.undecodable))
                    return
                }
                callback(.success(responseJson))
            
            }
            
        }
        task?.resume()
    }
}


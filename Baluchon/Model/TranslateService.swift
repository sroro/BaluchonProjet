//
//  TranslateService.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 25/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

final class TranslateService {
    
    private let session : URLSession
    private var task: URLSessionDataTask?
    
    init(session:URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    enum NetworkError: Error {
        case noData, noResponse, undecodable
    }
    
    /// recupere la traduction d'un paragraphe vers une autre langue
    func getTranslate(text: String, target: String, callback: @escaping (Result<TranslateData, Error> ) -> Void) {
        //encodage  de l'url pour éviter les espaces
        guard let textEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let translaterUrl = URL(string: "https://translation.googleapis.com/language/translate/v2?key=AIzaSyAYPTSUKkQREezQHLdzUbTwPiMesKintas&q=\(textEncoded)&source=fr&target=\(target)&format=text") else {return}   
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


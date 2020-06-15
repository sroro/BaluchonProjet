//
//  FixerFakeResponseData.swift
//  BaluchonTests
//
//  Created by Rodolphe Schnetzer on 07/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

class TestFakeResponseData {
    
    // 1-simuler 2 types de reponses.
    static let responseOK = HTTPURLResponse(url: URL(string:"https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: [:])
    static let responseKO = HTTPURLResponse(url: URL(string:"https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: [:])
    
    
    class FixerError : Error { }
    static let error = FixerError()
    
    // 2-Json avec données correct
    static var fixerCorrectData: Data {
        let bundle = Bundle(for: TestFakeResponseData.self)
        let url = bundle.url(forResource: "Fixer", withExtension: "json")!
        
        return try! Data(contentsOf: url)
    }
    
    static var weatherCorrectData: Data {
        let bundle = Bundle(for: TestFakeResponseData.self)
        let url = bundle.url(forResource: "Weather", withExtension: "json")!
        
        return try! Data(contentsOf: url)
    }
    
    static var translateCorrectData : Data {
        let bundle = Bundle(for: TestFakeURLSession.self)
        let url = bundle.url(forResource: "Translate", withExtension: "json")!
          return try! Data(contentsOf: url)
    }
    
    
    // 3-Json endommagé
    static let incorrectData = "erreur".data(using: .utf8)
    
}

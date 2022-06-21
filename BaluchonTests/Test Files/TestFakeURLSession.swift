//
//  FixerFakeURLSession.swift
//  BaluchonTests
//
//  Created by Rodolphe Schnetzer on 07/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

class TestFakeURLSession : URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(data: data, urlResponse: response, error: error, completionHandler: completionHandler)
        return task
    }
    
    
}

class URLSessionDataTaskFake : URLSessionDataTask {
    
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError : Error?
    
    init(data:Data? , urlResponse: URLResponse? , error: Error? , completionHandler:((Data?, URLResponse?, Error?) -> Void)? ) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = error
        self.completionHandler = completionHandler
        
    }
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    override func cancel() {}
}

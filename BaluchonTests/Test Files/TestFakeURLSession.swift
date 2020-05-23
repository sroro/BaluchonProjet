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
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.data = data
        task.urlResponse = response
        task.responseError = error
        return task
    }
    
    
}

class URLSessionDataTaskFake : URLSessionDataTask {
    
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError : Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    override func cancel() {}
}

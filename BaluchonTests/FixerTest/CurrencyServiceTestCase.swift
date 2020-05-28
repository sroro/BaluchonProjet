//
//  CurrencyServiceTestCase.swift
//  BaluchonTests
//
//  Created by Rodolphe Schnetzer on 29/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import XCTest
@testable import Baluchon

class CurrencyServiceTestCase: XCTestCase {
    
    // fausse erreur
    func testgetExchangeShouldPostFailedCallbackIfError() {
        
        // Given
        let fixerExchange = CurrencyService(session:TestFakeURLSession(data: nil, response: nil, error: TestFakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "wait for queue change")
        fixerExchange.getExchange(devise: "USD") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("testgetExchangeShouldPostFailedCallbackIfError fail")
                return
            }
            XCTAssertNotNil(error)
            
            // Then
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    // aucune données
    func testgetExchangeReceiveNoData() {
        
        let fixerExchange = CurrencyService(session:TestFakeURLSession(data: nil, response: nil, error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        fixerExchange.getExchange(devise: "USD") { (result) in
            
            guard case .failure(let error) = result else {
                XCTFail("testgetExchangeReceiveNoData fail")
                return
            }
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    // reponse KO
    
    func testgetExchangeReceiveGoodDataButResponseKO() {
        
        let fixerExchange = CurrencyService(session: TestFakeURLSession(data:TestFakeResponseData.fixerCorrectData , response: TestFakeResponseData.responseKO , error: nil))
        
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        fixerExchange.getExchange(devise: "USD") { (result) in
            guard case .failure (let error) = result else {
                XCTFail("testgetExchangeReceiveNoData fail")
                return
            }
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    func testgetExchangeCorrectDataAndResponse() {
        
        let fixerExchange = CurrencyService(session: TestFakeURLSession(data:TestFakeResponseData.fixerCorrectData , response: TestFakeResponseData.responseOK , error: nil))
        
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        fixerExchange.getExchange(devise: "USD") { (result) in
            guard case .success (let data) = result else {
                 XCTFail("testgetExchangeCorrectDataAndResponse fail")
                return
            }
            
            //XCTAssertEqual(data, 1.089444)
          XCTAssertEqual(data, 1.081695)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    func testUndecodableData() {
        let fixer = CurrencyService(session: TestFakeURLSession(data:TestFakeResponseData.incorrectData, response: TestFakeResponseData.responseOK , error: nil))
        let expectation = XCTestExpectation(description: "wait for queue change")
        fixer.getExchange (devise: "USD"){ (result) in
               guard case .failure (let error ) = result  else {
                   XCTFail("testgetWeatherShouldPostFailedCallbackIfError fail")
                   return
               }
                   
                   XCTAssertNotNil(error)
                   
                   expectation.fulfill()
               }
               wait(for: [expectation], timeout: 0.01)
    }
    
}

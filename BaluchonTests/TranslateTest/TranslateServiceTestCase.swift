//
//  TranslateServiceTestCase.swift
//  BaluchonTests
//
//  Created by Rodolphe Schnetzer on 07/06/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import XCTest
@testable import Baluchon
class TranslateServiceTestCase: XCTestCase {
    
    func testgetWeatherShouldPostFailedCallbackIfError(){
        let translate = TranslateService(session: TestFakeURLSession(data: nil, response: nil, error: TestFakeResponseData.error ))
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        translate.getTranslate(text: "j'ai faim", target: "en") { (result) in
            guard case .failure (let error ) = result  else {
                XCTFail("testgetWeatherShouldPostFailedCallbackIfError fail")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testgetWeatherReceiveGoodDataButResponseKO() {
        
        let translate = TranslateService(session: TestFakeURLSession(data:TestFakeResponseData.translateCorrectData , response: TestFakeResponseData.responseKO , error: nil))
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        translate.getTranslate(text: "j'ai faim", target: "en") { (result) in
            guard case .failure (let error ) = result  else {
                XCTFail("testgetWeatherShouldPostFailedCallbackIfError fail")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testgetExchangeCorrectDataAndResponse() {
        let translate = TranslateService(session: TestFakeURLSession(data:TestFakeResponseData.translateCorrectData , response: TestFakeResponseData.responseOK , error: nil))
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        translate.getTranslate(text: "j'ai faim", target: "en"){ (result) in
            guard case .success (let data) = result else {
                XCTFail("testgetExchangeCorrectDataAndResponse fail")
                return
            }
            
            XCTAssertEqual(data.data.translations[0].translatedText , "I'm hungry")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
        
    }
    
    func testUndecodable() {
        let translate = TranslateService(session: TestFakeURLSession(data:TestFakeResponseData.incorrectData, response: TestFakeResponseData.responseOK , error: nil))
        let expectation = XCTestExpectation(description: "wait for queue change")
        translate.getTranslate(text: "j'ai faim", target: "en"){ (result) in
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

//
//  WeatherServiceTestCase.swift
//  BaluchonTests
//
//  Created by Rodolphe Schnetzer on 09/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import XCTest
@testable import Baluchon

class WeatherServiceTestCase : XCTestCase {
    
    
    func testgetWeatherShouldPostFailedCallbackIfError(){
        let weather = WeatherService(session: TestFakeURLSession(data: nil, response: nil, error: TestFakeResponseData.error ))
        let expectation = XCTestExpectation(description: "wait for queue change")
        weather.getWeather { (result) in
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
        let weather = WeatherService(session: TestFakeURLSession(data:TestFakeResponseData.weatherCorrectData , response: TestFakeResponseData.responseKO , error: nil))
        let expectation = XCTestExpectation(description: "wait for queue change")
        weather.getWeather { (result) in
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
        let weather = WeatherService(session: TestFakeURLSession(data:TestFakeResponseData.weatherCorrectData , response: TestFakeResponseData.responseOK , error: nil))
        let expectation = XCTestExpectation(description: "wait for queue change")
        weather.getWeather{ (result) in
            guard case .success (let data) = result else {
                XCTFail("testgetExchangeCorrectDataAndResponse fail")
                return
            }
            XCTAssertEqual(data.list[0].name, "Paris")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testUndecodable() {
        let weather = WeatherService(session: TestFakeURLSession(data:TestFakeResponseData.incorrectData, response: TestFakeResponseData.responseOK , error: nil))
        let expectation = XCTestExpectation(description: "wait for queue change")
        weather.getWeather { (result) in
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



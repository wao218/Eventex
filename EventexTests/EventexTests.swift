//
//  EventexTests.swift
//  EventexTests
//
//  Created by Wesley Osborne on 1/25/21.
//

import XCTest
@testable import Eventex

class EventexTests: XCTestCase {
  var sut: URLSession!
  

  override func setUpWithError() throws {
    sut = URLSession(configuration: .default)
  }

  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testValidCallToSeatGeekAPI() throws {
    // given
    let clientID = ProcessInfo.processInfo.environment["CLIENTID"]
    let url = URL(string: "https://api.seatgeek.com/2/events?client_id=\(clientID!)&q=nba&per_page=200")
    let promise = expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    // when
    let dataTask = sut.dataTask(with: url!) { (data, response, error) in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }
    dataTask.resume()
    wait(for: [promise], timeout: 5)
    
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }

}

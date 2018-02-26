//
//  iss_passesTests.swift
//  iss-passesTests
//
//  Created by MCS Devices on 12/7/17.
//  Copyright © 2017 Mobile Consulting Solutions. All rights reserved.
//

import XCTest
@testable import iss_passes

class iss_passesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
  func testUrlParam() {
    let testNetworkObject = NetworkManager()
    let urlTest = testNetworkObject.createURLFromParameters(parameters: ["lat":37.785834, "lon":122.406417])
    XCTAssertTrue(urlTest.absoluteString.contains(find: "lon"), "Cannot convert to URLRequest with the params specified");
  }
  
  func testTimestampToDateString() {
    let date: Double =  1512705657
    XCTAssertTrue((date.timestampToDateString() != ""), "Conversion to string date format from double fail");
  }
  
}

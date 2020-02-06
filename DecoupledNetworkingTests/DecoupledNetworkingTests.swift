//
//  DecoupledNetworkingTests.swift
//  DecoupledNetworkingTests
//
//  Created by Alex on 05/02/2020.
//  Copyright © 2020 tonezone6. All rights reserved.
//

import XCTest
@testable import DecoupledNetworking

class DecoupledNetworkingTests: XCTestCase {
   
    override func setUp() {}
    override func tearDown() {}

    func testApiCallFailure() {
        let url = URL(fileURLWithPath: "url")
        let resource = Resource<Comment>(get: url)
        
        let session = MockURLSession()
        session.error = MockError.unknown
        session.load(resource) {
            if case .failure(let error) = $0 {
                return XCTAssertEqual(error.localizedDescription, "Unknown error.")
            }
            XCTFail()
        }
    }
    
    func testApiCallDecodingError() {
        let url = URL(fileURLWithPath: "url")
        let resource = Resource<Comment>(get: url)
        
        let session = MockURLSession()
        session.data = """
        {
            "id": "1",
            "name": "name",
            "body": "body"
        }
        """.data(using: .utf8)
        session.load(resource) {
            if case .failure(let error) = $0 {
                return XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
            }
            XCTFail()
        }
    }
    
    func testApiCallSuccess() {
        let url = URL(fileURLWithPath: "url")
        let resource = Resource<Comment>(get: url)
        
        let session = MockURLSession()
        session.data = """
        {
            "id": 1,
            "name": "name",
            "body": "body"
        }
        """.data(using: .utf8)
        
        let exp = expectation(description: "exp")

        session.load(resource) {
            print($0)
            exp.fulfill()
            if case .success(let output) = $0 {
                XCTAssertEqual(output.id, 1)
                XCTAssertEqual(output.name, "name")
                XCTAssertEqual(output.body, "body")
                return
            }
            XCTFail()
        }
        wait(for: [exp], timeout: 0.1)
    }
}

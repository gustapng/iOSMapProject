//
//  BaseServiceTests.swift
//  iOSMapProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 10/12/24.
//

import XCTest
@testable import iOSMapProject

final class BaseServiceTests: XCTestCase {
    var baseService: BaseService!
    
    override func setUp() {
        super.setUp()
        baseService = BaseService()
    }

    override func tearDown() {
        baseService = nil
        super.tearDown()
    }

    func testCreateURLValidURL() {
        let validURLString = APIConstants.baseURL

        let result = baseService.createURL(from: validURLString)

        switch result {
        case .success(let url):
            XCTAssertEqual(url.absoluteString, validURLString)
        case .failure:
            XCTFail("Error")
        }
    }

    func testCreateURLInvalidURL() {
        let invalidURLString = "invalid_url"

        let result = baseService.createURL(from: invalidURLString)

        switch result {
        case .success:
            XCTFail("Unexpected success")
        case .failure(let error):
            XCTAssertEqual(error.errorCode, "invalid_url")
            XCTAssertEqual(error.errorDescription, "URL inválida")
        }
    }

    func testSerializeBodyValidBody() {
        let body: [String: Any] = [
            "customer_id": "CT01",
            "origin": "testOrigin",
            "destination": "testDestination"
        ]

        let result = baseService.serializeBody(body)

        switch result {
        case .success(let data):
            XCTAssertNotNil(data)

            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                XCTAssertNotNil(json)
            }
        case .failure:
            XCTFail("Error")
        }
    }
}

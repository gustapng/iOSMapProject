//
//  DistanteFormatterToKm.swift
//  iOSMapProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 10/12/24.
//

import XCTest
@testable import iOSMapProject

final class DistanceFormatToKmTests: XCTestCase {
    func testDistanceFormatToKmTestWithInteger() {
        let distanceInMeters: Int = 1500

        let formattedDistance = distanceInMeters.formatDistanceToKM()

        XCTAssertEqual(formattedDistance, "1.50 km")
    }

    func testFormatDistanceToKMWithDecimal() {
        let distanceInMeters: Int = 1234

        let formattedDistance = distanceInMeters.formatDistanceToKM()

        XCTAssertEqual(formattedDistance, "1.23 km")
    }

    func testFormatDistanceToKMWithZero() {
        let distanceInMeters: Int = 0

        let formattedDistance = distanceInMeters.formatDistanceToKM()

        XCTAssertEqual(formattedDistance, "0.00 km")
    }

    func testFormatDistanceToKMWithLargeValue() {
        let distanceInMeters: Int = 1000000

        let formattedDistance = distanceInMeters.formatDistanceToKM()

        XCTAssertEqual(formattedDistance, "1000.00 km")
    }

    func testFormatDistanceToKMWithNegativeValue() {
        let distanceInMeters: Int = -1000

        let formattedDistance = distanceInMeters.formatDistanceToKM()

        XCTAssertEqual(formattedDistance, "-1.00 km")
    }
}

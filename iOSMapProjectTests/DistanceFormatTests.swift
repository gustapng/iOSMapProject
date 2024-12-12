//
//  DistanceFormatterTests.swift
//  iOSMapProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 09/12/24.
//

import XCTest
@testable import iOSMapProject

final class DistanceFormatTests: XCTestCase {
    func testDistanceFormatTestWithInteger() {
        let distance: Double = 1000.0

        let formattedDistance = distance.formatDistance()

        XCTAssertEqual(formattedDistance, "1.000,00")
    }

    func testFormatDistanceWithDecimal() {
        let distance: Double = 1500.55

        let formattedDistance = distance.formatDistance()

        XCTAssertEqual(formattedDistance, "1.500,55")
    }

    func testFormatDistanceWithNegativeValue() {
        let distance: Double = -1000.99

        let formattedDistance = distance.formatDistance()

        XCTAssertEqual(formattedDistance, "-1.000,99")
    }

    func testFormatDistanceWithZero() {
        let distance: Double = 0.0

        let formattedDistance = distance.formatDistance()

        XCTAssertEqual(formattedDistance, "0,00")
    }
}

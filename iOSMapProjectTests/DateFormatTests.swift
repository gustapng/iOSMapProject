//
//  DateFormatTests.swift
//  iOSMapProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 10/12/24.
//

import XCTest
@testable import iOSMapProject

final class DateFormatTests: XCTestCase {
    func testDateFormatTestValidDate() {
        let dateString = "2025-01-06T08:00:00"

        let formattedDate = dateString.formatDate()

        XCTAssertEqual(formattedDate, "06/01/2025 08:00")
    }

    func testFormatDateInvalidDate() {
        let invalidDateString = "10-12-2024 21:11:00"

        let formattedDate = invalidDateString.formatDate()

        XCTAssertNil(formattedDate)
    }

    func testFormatDateEmptyString() {
        let emptyDateString = ""

        let formattedDate = emptyDateString.formatDate()

        XCTAssertNil(formattedDate)
    }
}

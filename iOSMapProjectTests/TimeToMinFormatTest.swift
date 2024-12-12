//
//  TimeToMinFormatTest.swift
//  iOSMapProjectTests
//
//  Created by Gustavo Ferreira dos Santos on 10/12/24.
//

import XCTest
@testable import iOSMapProject

final class TimeToMinFormatTest: XCTestCase {
    func testTimeToMinFormatTestValidTimeHourOneDigit() {
        let timeString = "12:5"

        let formattedTime = timeString.formatTimeToMin()

        XCTAssertEqual(formattedTime, "12:05")
    }

    func testTimeToMinFormatTestValidTimeMinuteOneDigit() {
        let timeString = "2:50"

        let formattedTime = timeString.formatTimeToMin()

        XCTAssertEqual(formattedTime, "02:50")
    }

    func testFormatTimeToMinInvalidTime() {
        let invalidTimeString = "12:30:45"

        let formattedTime = invalidTimeString.formatTimeToMin()

        XCTAssertEqual(formattedTime, invalidTimeString)
    }

    func testFormatTimeToMinInvalidCharacterNotNumeric() {
        let invalidTimeString = "12:XX"

        let formattedTime = invalidTimeString.formatTimeToMin()

        XCTAssertEqual(formattedTime, invalidTimeString)
    }

    func testFormatTimeToMinEmptyString() {
        let emptyTimeString = ""

        let formattedTime = emptyTimeString.formatTimeToMin()

        XCTAssertEqual(formattedTime, emptyTimeString)
    }
}

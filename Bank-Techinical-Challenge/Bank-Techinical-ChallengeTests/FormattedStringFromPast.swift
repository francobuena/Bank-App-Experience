//
//  Form.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 25/3/2025.
//

import Foundation
import XCTest

final class FormattedStringFromPastTest: XCTestCase {
    
    func testFormattedStringFromPast() {
        let fixedDate = Calendar.current.date(from: DateComponents(
            year: 2025,
            month: 3,
            day: 24,
            hour: 14,
            minute: 31
        ))!
        XCTAssertEqual(fixedDate.formattedStringFromPast(days: 7), "2025-03-17T03:31:00Z")
    }
}

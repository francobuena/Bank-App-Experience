//
//  Int+ConvertToStringTests.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 25/3/2025.
//

import Foundation
import XCTest

final class ConvertToStringTest: XCTestCase {
    
    func testConvertToStringTest() {
        let amount = 44931
        XCTAssertEqual(amount.convertToString(), "449.31")
    }
}

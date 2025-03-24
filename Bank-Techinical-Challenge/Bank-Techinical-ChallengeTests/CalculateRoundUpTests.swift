//
//  CalculateRoundUpTests.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 25/3/2025.
//

import Foundation
import XCTest

final class CalculateRoundUpTest: XCTestCase {
    
    let transactionList: TransactionList = TransactionList(feedItems: [
        Transaction(feedItemId: "", categoryId: "", amount: Amount(currency: "GBP", minorUnits: 1067), direction: "OUT", status: "SETTLED", counterPartyName: "ATO"),
        Transaction(feedItemId: "", categoryId: "", amount: Amount(currency: "GBP", minorUnits: 15032), direction: "OUT", status: "SETTLED", counterPartyName: "Woolworths"),
        Transaction(feedItemId: "", categoryId: "", amount: Amount(currency: "GBP", minorUnits: 20047), direction: "IN", status: "SETTLED", counterPartyName: "Cotton On"),
        Transaction(feedItemId: "", categoryId: "", amount: Amount(currency: "GBP", minorUnits: 3055), direction: "OUT", status: "SETTLED", counterPartyName: "Mickey Mouse"),
        Transaction(feedItemId: "", categoryId: "", amount: Amount(currency: "GBP", minorUnits: 244), direction: "IN", status: "SETTLED", counterPartyName: "Candy")
    ])
    
    func testCalculateRoundUpAmount() {
        XCTAssertEqual(transactionList.calculateRoundUp(), 146)
    }
}

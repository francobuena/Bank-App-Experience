//
//  TransactionFeed.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

struct TransactionList: Codable {
    let feedItems: [Transaction]
}

struct Transaction: Codable {
    let feedItemId: String
    let categoryId: String
    let amount: Amount
    let direction: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case amount, direction, status
        case feedItemId = "feedItemUid"
        case categoryId = "categoryUid"
    }
}

struct Amount: Codable {
    let currency: String
    let minorUnits: Int // TODO: Create mapper to update this value to the pence amount
}

extension TransactionList {
    
    func calculateRoundUp() -> Int {
        var roundUp = 0
        
        // Filter outbound and settled transactions
        let outboundTransactions = feedItems
            .filter { $0.direction == "OUT" && $0.status == "SETTLED" }
        
        for item in outboundTransactions {
            let minorUnits = item.amount.minorUnits
            let remainder = minorUnits % 100
            if remainder > 0 {
                roundUp += (100 - remainder)
            }
        }
        
        return roundUp
    }
}

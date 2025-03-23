//
//  TransactionFeed.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

struct TransactionList: Codable {
    let feedItems: [Transaction]
}

struct Transaction: Codable, Identifiable {
    let feedItemId: String
    let categoryId: String
    let amount: Amount
    let direction: String
    let status: String
    let counterPartyName: String
    
    enum CodingKeys: String, CodingKey {
        case amount, direction, status, counterPartyName
        case feedItemId = "feedItemUid"
        case categoryId = "categoryUid"
    }
    
    var id: String { feedItemId }
}

struct Amount: Codable {
    let currency: String
    let minorUnits: Int
}

extension TransactionList {
    
    func calculateRoundUp() -> Int {
        var roundUp = 0
        
        // Ensure we only get transactions that are outbound and settled
        let transactions = feedItems
            .filter { $0.direction == "OUT" && $0.status == "SETTLED" }
        
        for item in transactions {
            let minorUnits = item.amount.minorUnits
            let remainder = minorUnits % 100
            if remainder > 0 {
                roundUp += (100 - remainder)
            }
        }
        
        return roundUp
    }
}

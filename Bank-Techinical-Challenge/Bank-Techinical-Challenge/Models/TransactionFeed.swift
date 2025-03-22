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

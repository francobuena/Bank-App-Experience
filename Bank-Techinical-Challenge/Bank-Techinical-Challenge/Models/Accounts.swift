//
//  Accounts.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

struct AccountsList: Codable {
    let accounts: [Account]
}

struct Account: Codable {
    let accountId: String
    let accountType: String
    let defaultCategory: String
    let currency: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case accountType, defaultCategory, currency, name
        case accountId = "accountUid"
    }
}

//
//  SavingsGoal.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

struct SavingsGoalList: Codable {
    let savingsGoalList: [SavingsGoal]
}

struct SavingsGoal: Codable {
    let savingsGoalId: String
    let name: String
    let target: Amount
    let totalSaved: Amount
    let savedPercentage: Int
    let state: String // TODO: change to enum type
    
    enum CodingKeys: String, CodingKey {
        case name, target, totalSaved, savedPercentage, state
        case savingsGoalId = "savingsGoalUid"
    }
}

struct SavingsGoalRequest: Codable {
    let name: String
    let currency: String
    let target: Amount
}

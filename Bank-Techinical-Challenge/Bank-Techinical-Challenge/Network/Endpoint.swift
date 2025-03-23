//
//  Endpoint.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

import Foundation

enum Endpoint {
    private struct Constants {
        static let baseURLString = "https://api-sandbox.starlingbank.com/"
        static let basePath = "api/v2/"
    }
    
    case user
    case accounts
    case transactions(accountId: String, categoryId: String, lastWeekDate: String)
    case savingsGoals(accountId: String, method: String, request: Data?)
    case addMoneyToGoal(accountId: String, savingsGoalId: String, transferId: String, method: String, request: Data?)
    
    private func path() -> String {
        switch self {
        case .user:
            return "account-holder/individual"
        case .accounts:
            return "accounts"
        case .transactions(let accountId, let categoryId, let lastWeekDate):
            // TODO: we need to move this changesSince parameter somewhere
            return "feed/account/\(accountId)/category/\(categoryId)?changesSince=\(lastWeekDate)"
        case .savingsGoals(let accountId, _, _):
            return "account/\(accountId)/savings-goals"
        case .addMoneyToGoal(let accountId, let savingsGoalId, let transferId, _, _):
            return "account/\(accountId)/savings-goals/\(savingsGoalId)/add-money/\(transferId)"
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .user, .accounts, .transactions:
            return "GET"
        case .savingsGoals(_, let method, _):
            return method
        case .addMoneyToGoal(_, _, _, let method, _):
            return method
        }
    }
    
    func request() throws -> URLRequest {
        guard let url = URL(string: "\(Constants.baseURLString)\(Constants.basePath)\(path())") else {
            throw NetworkError.malformedURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        switch self {
        case .savingsGoals(_, _, let body):
            if let body {
                request.httpBody = body
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        case .addMoneyToGoal(_, _, _, _, let body):
            if let body {
                request.httpBody = body
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        default:
            break
        }
        
        return request
    }
}


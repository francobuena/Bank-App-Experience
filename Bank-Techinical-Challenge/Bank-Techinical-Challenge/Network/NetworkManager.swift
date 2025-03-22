//
//  NetworkManager.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

import Foundation

enum NetworkError: Error {
    case malformedURL
    case invalidResponse
    case unauthorized
    case serverError(String)
}

protocol Service {
    func fetchAccounts() async throws -> AccountsList
    func fetchTransactions(accountId: String, categoryId: String) async throws -> TransactionList
    func fetchGoals(accountId: String) async throws -> SavingsGoalList
    func createGoal(accountId: String, body: Data) async throws
}

struct Config: Decodable {
    let apiToken: String
}

class NetworkManager: Service {
    
    private let session = URLSession(configuration: .default)
    private let token: String
    
    init() {
        if let path = Bundle.main.path(forResource: "config", ofType: "plist"),
           let data = FileManager.default.contents(atPath: path),
           let config = try? PropertyListDecoder().decode(Config.self, from: data) {
            token = config.apiToken
        } else {
            token = ""
            fatalError("Failed to load API token from configuration file.")
        }
    }
    
    func performRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        do {
            var request = try endpoint.request()
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            // Success case
            case 200...299:
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.serverError("Server returned status code: \(httpResponse.statusCode)")
            }
            
        }
    }
    
    func sendRequest(_ endpoint: Endpoint) async throws {
        do {
            var request = try endpoint.request()
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            // Success case
            case 200...299:
                return
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.serverError("Server returned status code: \(httpResponse.statusCode)")
            }
        }
    }
    
    func fetchAccounts() async throws -> AccountsList {
        try await performRequest(.accounts)
    }
    
    func fetchTransactions(accountId: String, categoryId: String) async throws -> TransactionList {
        try await performRequest(.transactions(accountId: accountId, categoryId: categoryId))
    }
    
    func fetchGoals(accountId: String) async throws -> SavingsGoalList {
        try await performRequest(.savingsGoals(accountId: accountId, method: "GET", request: nil))
    }
    
    func createGoal(accountId: String, body: Data) async throws {
        try await sendRequest(.savingsGoals(accountId: accountId, method: "PUT", request: body))
    }
}

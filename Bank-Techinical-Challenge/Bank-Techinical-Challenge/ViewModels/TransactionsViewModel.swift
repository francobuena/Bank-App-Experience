//
//  AccountsViewModel.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//

import Foundation

@MainActor
class TransactionsViewModel: ObservableObject {
    private let service: Service
    @Published var accounts: AccountsList?
    @Published var transactions: TransactionList?
    @Published var roundUp: Double?
    @Published var isLoading = false
    
    init(service: Service) {
        self.service = service
    }
    
    func loadData() async {
        
        isLoading = true
        do {
            accounts = try await service.fetchAccounts()
            transactions = try await service.fetchTransactions(
                accountId: "273a141f-3060-46bb-bca9-78d8c823f30f",
                categoryId: "273a30f2-165e-4e8e-976f-9cc138dd1f5f"
            )
            let amount = transactions?.calculateRoundUp()
            roundUp = Double(amount ?? 0) / 100
            await addMoneyToGoal(amount: amount ?? 0)
            isLoading = false
        } catch {
            // TODO: Improve error handling
            print("ERROR: \(error)")
        }
    }
    
    func addMoneyToGoal(amount: Int) async {
        isLoading = true
        let request = TopUpRequest(
            amount: Amount(currency: "GBP", minorUnits: amount)
        )
        print("REQUEST", request)
        let transferUid = UUID().uuidString.lowercased()
        print("UUID", transferUid)
        defer {
            isLoading = false
        }
        
        do {
            let encoder = JSONEncoder()
            let body = try encoder.encode(request)
            try await service.addMoneyToGoal(
                accountId: "273a141f-3060-46bb-bca9-78d8c823f30f",
                savingsGoalId: "27a5fad2-52a8-4ff5-b81c-9359c73b7a5e",
                transferId: transferUid,
                body: body)
        } catch {
            // TODO: Improve error handling
            print("Failed to update goal: \(error)")
        }
    }

}

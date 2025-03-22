//
//  AccountsViewModel.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 22/3/2025.
//
import Foundation

@MainActor
class AccountsViewModel: ObservableObject {
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
            transactions = try await service.fetchTransactions(accountId: "273a141f-3060-46bb-bca9-78d8c823f30f", categoryId: "273a30f2-165e-4e8e-976f-9cc138dd1f5f")
            roundUp = Double(transactions?.calculateRoundUp() ?? 0) / 100
            isLoading = false
        } catch {
            print("ERROR: \(error)")
        }
    }

}

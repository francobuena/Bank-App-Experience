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
    @Published var accountsList: AccountsList?
    @Published var transactions: TransactionList?
    @Published var savingGoals: SavingsGoalList?
    @Published var user: User?
    @Published var roundUp: Int?
    @Published var isTransferring = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var screenState: ScreenState = .loading
    @Published var errorMessage = ""
    
    init(service: Service) {
        self.service = service
    }
    
    func loadTransactions() async {
        screenState = .loading
        let pastWeekDate = Date().formattedStringFromPast(days: 7)
        do {
            user = try await service.fetchUser()
            accountsList = try await service.fetchAccounts()
            transactions = try await service.fetchTransactions(
                accountId: accountsList?.accounts[0].accountId ?? "",
                categoryId: accountsList?.accounts[0].defaultCategory ?? "",
                pastWeekDate: pastWeekDate
            )
            roundUp = transactions?.calculateRoundUp()
            screenState = .success
        } catch {
            screenState = .error
            errorMessage = "\(error.localizedDescription)"
        }
    }
    
    func addMoneyToGoal(amount: Int) async {
        isTransferring = true
        let request = TopUpRequest(
            amount: Amount(currency: "GBP", minorUnits: amount)
        )
        let transferUid = UUID().uuidString.lowercased()
        
        defer {
            isTransferring = false
            showAlert = true
        }
        
        do {
            let encoder = JSONEncoder()
            let body = try encoder.encode(request)
            try await service.addMoneyToGoal(
                accountId: accountsList?.accounts[0].accountId ?? "",
                savingsGoalId: "2b86d6e9-b062-4fb3-b838-6df55820d5a4",
                transferId: transferUid,
                body: body)
            alertTitle = "Success!"
            alertMessage = "You have transferred to your Savings Goal"
        } catch {
            alertTitle = "Error"
            alertMessage = "Something went wrong: \(error.localizedDescription)"
        }
    }

}

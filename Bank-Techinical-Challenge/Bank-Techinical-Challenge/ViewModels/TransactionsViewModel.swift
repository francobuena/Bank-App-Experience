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
    @Published var transactions: TransactionList?
    @Published var user: User?
    @Published var roundUp: Int?
    @Published var isLoading = false
    @Published var isTransferring = false
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(service: Service) {
        self.service = service
    }
    
    func loadData() async {
        isLoading = true
        let currentDate = Date()
        let pastWeekDate = currentDate.formattedStringFromPast(days: 7)
        print(pastWeekDate)
        do {
            user = try await service.fetchUser()
            transactions = try await service.fetchTransactions(
                accountId: "273a141f-3060-46bb-bca9-78d8c823f30f",
                categoryId: "273a30f2-165e-4e8e-976f-9cc138dd1f5f",
                pastWeekDate: pastWeekDate
            )
            roundUp = transactions?.calculateRoundUp()
            isLoading = false
        } catch {
            print("ERROR: \(error)")
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
                accountId: "273a141f-3060-46bb-bca9-78d8c823f30f",
                savingsGoalId: "2b8239b4-371b-4761-a5de-48668826dba1",
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

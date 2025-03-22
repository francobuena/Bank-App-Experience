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
    @Published var isLoading = false
    
    init(service: Service) {
        self.service = service
    }
    
    func loadData() async {
        isLoading = true
        do {
            accounts = try await service.fetchAccounts()
            isLoading = false
        } catch {
            print("ERROR: \(error)")
        }
    }

}

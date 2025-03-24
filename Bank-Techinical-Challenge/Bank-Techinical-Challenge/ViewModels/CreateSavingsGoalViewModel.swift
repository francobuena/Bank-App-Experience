//
//  CreateSavingsGoalViewModel.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 24/3/2025.
//

import Foundation

@MainActor
class CreateSavingGoalViewModel: ObservableObject {
    private let service: Service
    var accountId: String = ""
    @Published var isCreatingGoal: Bool = false
    @Published var screenState: ScreenState = .loading
    @Published var showTextfieldError: Bool = false
    @Published var textfieldErrorMessage: String = ""
    @Published var savingsGoalName: String = ""
    @Published var savingsGoalAmount: String = ""
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(service: Service,
         accountId: String
    ) {
        self.service = service
        self.accountId = accountId
    }
    
    func createSavingsGoal() async {
        let minorUnits = (Int(savingsGoalAmount) ?? 0) * 100
        let request = SavingsGoalRequest(
            name: savingsGoalName,
            currency: "GBP",
            target: Amount(
                currency: "GBP",
                minorUnits: minorUnits
            )
        )
        
        defer {
            isCreatingGoal = false
            if isInputValid() {
                showAlert = true
            }
        }
        
        if isInputValid() {
            isCreatingGoal = true
            showTextfieldError = false
            do {
                let encoder = JSONEncoder()
                let body = try encoder.encode(request)
                try await service.createGoal(
                    accountId: accountId,
                    body: body
                )
                alertTitle = "Success!"
                alertMessage = "You have created your Savings Goal"
            } catch {
                alertTitle = "Error"
                alertMessage = "\(error.localizedDescription)"
                print("Create goal error: \(error.localizedDescription)")
            }
        } else {
            showTextfieldError = true
        }
    }
    
    func isInputValid() -> Bool {
        
        switch (savingsGoalName, savingsGoalAmount) {
        case (let name, let amount):
            if name.isEmpty || amount.isEmpty {
                textfieldErrorMessage = "Please fill in the required fields"
                return false
            }
            if let numAmount = Int(amount), numAmount > 0 {
                return true
            } else {
                textfieldErrorMessage = "Please enter an amount greater than zero"
                return false
            }
        }
    }
    
    func dismissAlert() {
        // reset states
        savingsGoalName = ""
        savingsGoalAmount = ""
        textfieldErrorMessage = ""
    }
}

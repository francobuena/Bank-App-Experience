//
//  CreateSavingsGoalView.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 24/3/2025.
//
import SwiftUI

struct CreateSavingsGoalView: View {
    @ObservedObject private var viewModel: CreateSavingGoalViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: CreateSavingGoalViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                createSavingGoalSection
                textFieldAndButtonSection
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("Okay", role: .cancel) {
                    viewModel.dismissAlert()
                    // TODO: Handle this better in the future
                    // Ideally would need a state to track what happened to create goal function
                    // and then use that logic to detemine what happens next
                    if viewModel.alertTitle == "Success!" {
                        dismiss()
                    }
                }
            } message: {
                Text(viewModel.alertMessage)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.body)
                    .foregroundColor(Color.white)
                }
            }
        }
    }
    
    private var createSavingGoalSection: some View {
        VStack {
            createSavingGoalCard
        }
        .padding(24)
        .background(Colors.topSectionColor)
    }
    
    private var textFieldAndButtonSection: some View {
        VStack {
            Spacer()
            textFieldSection
            Spacer()
            createSavingGoalButton
            Spacer()
        }
        .background(Colors.transactionBackgroundColor)
    }
    
    private var textFieldSection: some View {
        VStack {
            TextField("Enter goal name", text: $viewModel.savingsGoalName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter dollar amount", text: $viewModel.savingsGoalAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            if viewModel.showTextfieldError {
                Text("\(viewModel.textfieldErrorMessage)")
                    .foregroundColor(Color.red)
            }
        }
    }
    
    private var createSavingGoalCard: some View {
        HStack {
            Text("Create Savings Goal")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    private var createSavingGoalButton: some View {
        Button {
            Task {
                await viewModel.createSavingsGoal()
            }
        } label: {
            if viewModel.isCreatingGoal {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                Text("Create Savings Goal")
                    .font(.body)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CreateSavingsGoalView(viewModel: CreateSavingGoalViewModel(service: NetworkManager(), accountId: ""))
}

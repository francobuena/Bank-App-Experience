//
//  ContentView.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 21/3/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = TransactionsViewModel(service: NetworkManager())
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching accounts...")
            } else {
                nameCard
                
//                if let accounts = viewModel.accounts?.accounts {
//                    VStack(alignment: .leading) {
//                        Text(accounts[0].name)
//                            .font(.headline)
//                    }
//                }
                
                roundUpSection
                Spacer()
            }
        }
        .padding(24)
        .task {
            await viewModel.loadData()
        }
    }
    
    private var nameCard: some View {
        HStack {
            Text("Hello, \(viewModel.user?.firstName ?? "")")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
    
    private var roundUpSection: some View {
        HStack {
            if let roundUp = viewModel.roundUp {
                VStack(alignment: .leading) {
                    Text("Your round up amount is £" + String(format: "%.2f", roundUp))
                        .font(.headline)
                    
                    Button {
                        Task {
                            await viewModel.addMoneyToGoal(amount: Int(roundUp))
                        }
                    } label: {
                        if viewModel.isTransferring {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Transfer to savings")
                                .font(.body)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 4)
    }
    
}


#Preview {
    ContentView()
}

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
                ProgressView("Fetching transactions...")
            } else {
                nameCard
                roundUpSection
                Divider()
                transactionList
            }
        }
        .padding(24)
        .task {
            await viewModel.loadData()
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {
                Task {
                    await viewModel.loadData()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
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
                    Text("Your round up amount is £" + roundUp.convertToString())
                        .font(.headline)
                    
                    Button {
                        Task {
                            await viewModel.addMoneyToGoal(amount: roundUp)
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
    
    private var transactionList: some View {
        ScrollView {
            VStack {
                if let transactionList = viewModel.transactions {
                    ForEach(transactionList.feedItems) { item in
                        VStack {
                            HStack {
                                Text("\(item.counterPartyName)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white)
                                Spacer()
                                Text("£\(item.amount.minorUnits.convertToString())")
                                    .foregroundColor(item.direction == "IN" ? Color.green : Color.white)
                            }
                            .padding(12)
                            .cornerRadius(10)
                            Divider()
                        }
                    }
                }
            }
            .padding(.top, 12)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


#Preview {
    ContentView()
}

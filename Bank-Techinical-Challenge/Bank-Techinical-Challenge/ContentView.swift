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
            switch viewModel.screenState {
            case .loading:
                ProgressView("Fetching transactions...")
            case .error:
                errorScreen
            case .success:
                homeScreen
            }
        }
        .task {
            await viewModel.loadTransactions()
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("Okay", role: .cancel) {
                Task {
                    await viewModel.loadTransactions()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    private var homeScreen: some View {
        VStack {
            userSection
            transactionSection
        }
    }
    
    private var userSection: some View {
        VStack {
            nameCard
            roundUpSection
        }
        .padding(24)
        .background(Colors.topSectionColor)
    }
    
    private var transactionSection: some View {
        VStack {
            transactionList
        }
        .background(Colors.transactionBackgroundColor)
    }
    
    private var nameCard: some View {
        HStack {
            Text("Hello, \(viewModel.user?.firstName ?? "")")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            Spacer()
        }
    }
    
    private var roundUpSection: some View {
        HStack {
            if let roundUp = viewModel.roundUp {
                VStack(alignment: .leading) {
                    Text("Your round up amount is £" + roundUp.convertToString())
                        .font(.headline)
                        .foregroundColor(Color.white)
                    
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
        .padding(.top, 2)
    }
    
    private var transactionList: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if let transactionList = viewModel.transactions {
                    ForEach(transactionList.feedItems) { item in
                        VStack {
                            HStack {
                                Text("\(item.counterPartyName)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("£\(item.amount.minorUnits.convertToString())")
                                    .foregroundColor(item.direction == "IN" ? Color.green : Colors.currencyFontColor)
                            }
                            .padding(12)
                            .cornerRadius(10)
                            Divider()
                        }
                    }
                }
            }
            .background(Colors.transactionCellColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(24)
    }
    
    private var errorScreen: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("Something went wrong")
                .font(.largeTitle)
            Text("\(viewModel.errorMessage)")
                .padding(.top, 4)
            Spacer()
            Button {
                Task {
                    await viewModel.loadTransactions()
                }
            } label: {
                Text("Try again")
                    .font(.body)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 12)
        }
        .padding(24)
    }
}

#Preview {
    ContentView()
}

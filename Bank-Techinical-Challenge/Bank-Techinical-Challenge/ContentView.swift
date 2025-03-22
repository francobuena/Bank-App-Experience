//
//  ContentView.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 21/3/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = AccountsViewModel(service: NetworkManager())
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Fetching accounts...")
            } else {
                Image(systemName: "dollarsign.bank.building")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("This is a bank")
                
                if let accounts = viewModel.accounts?.accounts {
                    VStack(alignment: .leading) {
                        Text(accounts[0].name)
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
        .task {
            await viewModel.loadData()
        }
    }
}

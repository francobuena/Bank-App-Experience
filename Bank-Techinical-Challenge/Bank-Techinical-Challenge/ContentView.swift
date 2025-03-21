//
//  ContentView.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 21/3/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "dollarsign.bank.building")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("This is a bank")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//
//  Int+ConvertToString.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 23/3/2025.
//

extension Int {
    func convertToString() -> String {
        let amount = Double(self) / 100
        return String(format: "%.2f", amount)
    }
}

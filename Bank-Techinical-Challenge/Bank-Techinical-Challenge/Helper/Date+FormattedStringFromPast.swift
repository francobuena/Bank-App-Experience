//
//  Date+ConvertToIsoString.swift
//  Bank-Techinical-Challenge
//
//  Created by Buena, Franco on 24/3/2025.
//

import Foundation

extension Date {
    
    // Calculate date from number of days and convert it to an ISO8601 string
    func formattedStringFromPast(days: Int) -> String {
        guard let pastDate = Calendar.current.date(byAdding: .day, value: -days, to: self) else { return "" }
        
        let isoFormatter = ISO8601DateFormatter()
        return isoFormatter.string(from: pastDate)
    }
    
}

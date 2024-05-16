//
//  Date+Extensions.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/23/24.
//

import SwiftUI

extension Date {
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

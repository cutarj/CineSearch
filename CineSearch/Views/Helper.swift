//
//  Helper.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import Foundation
import SwiftUI

struct RedactingView<Input: View, Output: View>: View {
    var content: Input
    var modifier: (Input) -> Output

    @Environment(\.redactionReasons) private var reasons

    var body: some View {
        if reasons.isEmpty {
            content
        } else {
            modifier(content)
        }
    }
}

// MARK: UI Design Helper Functions
extension View {
    
    // MARK: Redacted
    func whenRedacted<T: View>(
        apply modifier: @escaping (Self) -> T
    ) -> some View {
        RedactingView(content: self, modifier: modifier)
    }
    
    // MARK: Custom Alignment
    
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

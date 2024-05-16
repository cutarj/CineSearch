//
//  TabItemModel.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 2/05/24.
//

import Foundation
import SwiftUI

struct TabItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
    let color: Color
}

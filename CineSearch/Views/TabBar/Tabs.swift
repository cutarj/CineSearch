//
//  Tabs.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 2/05/24.
//

import Foundation

enum Tabs: CaseIterable {
    case home, discover, search, profile
    var item: TabItem {
        switch self {
            case .home:
                .init(title: "Home", systemImage: "house", color: .blue)
            case .discover:
                .init(title: "Discover", systemImage: "sparkles", color: .orange)
            case .search:
                .init(title: "Search", systemImage: "magnifyingglass", color: .purple)
            case .profile:
                .init(title: "Favorites", systemImage: "heart", color: .red)
        }
    }
}

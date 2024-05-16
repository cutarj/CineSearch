//
//  ContentView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack {
            TabBarView()
        }
        .onAppear() {
            UINavigationBar.appearance().barStyle = .black
            UITabBar.appearance().barStyle = .black
        }
    }
}

#Preview {
    ContentView()
}

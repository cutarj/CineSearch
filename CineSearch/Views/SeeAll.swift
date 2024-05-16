//
//  SeeAll.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct SeeAll: View {
    
    @State var title = ""
    @State var allMovies: [Movie] = []
    @Environment(\.dismiss) var dismiss
    
    init(movies: [Movie], title: String) {
        _allMovies = State(initialValue: movies)
        _title = State(initialValue: title)
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        VerticalTileView(movies: allMovies)
                    } header: {
                        HeaderView()
                    }
                    .padding(.horizontal, 2)
                }
                .padding(.bottom, 75)
            }
            .background(.brandBlack)
            .ignoresSafeArea(.container, edges: .top)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: Header View
    func HeaderView() -> some View {
        LazyVStack(alignment: .center, spacing: 10) {
            
            HStack {
                
                // MARK: Close Button
                Button(action: { dismiss() }, label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                })
                .padding(.leading, 20)
                
                Spacer()
                
                // MARK: Title
                Text(title)
                    .hCenter()
                    .padding(.leading, -35) // - (15) padding + (20) arrow.left width
                    .foregroundStyle(.brandOffWhite)
                    .font(Font.custom("Poppins-Medium", size: 25))
                
                Spacer()
            }
        }
        .padding(.bottom, 10)
        .padding(.top, getSafeArea().top + 10)
        .background(.ultraThinMaterial)
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    SeeAll(movies: [Movie](), title: "Popular Now")
}

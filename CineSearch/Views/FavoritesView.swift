//
//  FavoritesView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/25/24.
//

import SwiftUI

struct FavoritesView: View {
    
    @State private var isActive: Bool = false
    @State private var favorites = [MovieDetails]()
    @ObservedObject private var movieManager = MovieManager()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedLayoutAppearance.normal.iconColor = .darkGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.backgroundEffect = UIBlurEffect(style: .dark)
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                    
                    Section {
                        FavoritesView()
                    } header: {
                        HeaderView()
                    }
                    .padding(.horizontal, 2)
                }
                .padding(.bottom, 75)
            }
            .background(.brandBlack)
            .ignoresSafeArea(.container, edges: .top)
            .onAppear {
                self.favorites = movieManager.loadFavorites()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func FavoritesView() -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 5) {
            
            ForEach(favorites) { movie in
                NavigationLink {
                    MovieDetail(movieId: movie.id, isActive: $isActive)
                } label: {
                    VStack {
                        AsyncImage(url: movie.posterURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 190, alignment: .center)
                                .clipShape(.rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                )
                        } placeholder: {
                            ShimmerEffectBox()
                                .clipShape(.rect(cornerRadius: 10))
                                .frame(width: 120, height: 190, alignment: .center)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 5)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
    
    // MARK: Header View
    func HeaderView() -> some View {
        LazyVStack(alignment: .center, spacing: 10) {
            
            HStack {
                
                // MARK: Title
                Text("Favorites")
                    .hLeading()
                    .padding(.leading, 13)
                    .foregroundStyle(.brandOffWhite)
                    .font(.largeTitle.bold())
            }
        }
        .padding(.bottom, 10)
        .padding(.top, getSafeArea().top + 40)
        .background(.ultraThinMaterial)
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    FavoritesView()
}

//
//  UpcomingView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct UpcomingView: View {
    
    @ObservedObject private var movieManager = MovieManager()
    @State private var isActive: Bool = false
    @State private var isFetched = false
    
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
        NavigationStack {
            List {
                ForEach(movieManager.upcomingMovies, id: \.release_date) { movie in
                    
                    NavigationLink {
                        MovieDetail(movieId: movie.id, isActive: $isActive)
                    } label: {
                        HStack(alignment: .top) {
                            VStack(alignment: .center) {
                                Text(movie.releaseDate.format("MMM"))
                                Text(movie.releaseDate.format("dd"))
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            .padding(10)
                            
                            VStack(alignment: .leading) {
                                AsyncImage(url: movie.posterURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 280, height: 170)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25),radius: 8, x: 5, y:10)
                                } placeholder: {
                                    ShimmerEffectBox()
                                        .clipShape(.rect(cornerRadius: 10))
                                        .frame(width: 280, height: 170, alignment: .center)
                                }
                                
                                Text(movie.title)
                                    .padding(.vertical, 5)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Coming \(movie.releaseDate.format("MMM")) \(movie.releaseDate.format("dd"))")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .background(.brandBlack)
                                
                                Text(movie.overview)
                                    .font(.caption2)
                                    .fontWeight(.light)
                                    .background(.brandBlack)
                                    .padding(.vertical, 5)
                                
                                Text(movie.genreNames.joined(separator: " . "))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .background(.brandBlack)
                                    .padding(.vertical, 5)
                                
                            }
                            .padding()
                        }
                    }
                    .foregroundStyle(.brandOffWhite)
                    .listRowBackground(K.Theme.black)
                    .navigationBarTitle("Coming Soon")
                }
                .listRowSeparator(.hidden)
            }
            .padding(.bottom, 50)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(.brandBlack)
        }
        .task {
            if !isFetched {
                await movieManager.getMovies(for: .upcoming)
                isFetched = true
            }
        }
    }
}

#Preview {
    UpcomingView()
}

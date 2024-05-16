//
//  HomeView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 4/22/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var isActive: Bool = false
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
            List {
                
                // MARK: Trending Now
                HStack {
                    Text("Trending")
                        .foregroundStyle(.brandOffWhite)
                        .font(Font.custom("Poppins-Bold", size: 30))
                    
                    Text("Now")
                        .foregroundStyle(.gray)
                        .font(Font.custom("Poppins-Medium", size: 30))
                }
                .padding(.top, 10)
                .listRowSeparator(.hidden)
                .listRowBackground(K.Theme.black)
                
                // MARK: Date Today Formatted
                Text(Date().formatted(.dateTime.weekday(.wide).month(.wide).day().year()))
                    .padding(.top, -30)
                    .padding(.leading, 3)
                    .listRowSeparator(.hidden)
                    .listRowBackground(K.Theme.black)
                    .foregroundStyle(.brandOffWhite.opacity(0.8))
                    .font(Font.custom("Poppins-Regular", size: 17))
                
                GradientBlurView()
                    .padding(.top, -50)
                    .padding(.bottom, -20)
                    .listRowSeparator(.hidden)
                    .listRowBackground(K.Theme.black)
                
                // MARK: Top Rated
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Top")
                            .foregroundStyle(.brandOffWhite)
                            .font(Font.custom("Poppins-SemiBold", size: 25))
                        
                        Text("Rated")
                            .foregroundStyle(.gray)
                            .font(Font.custom("Poppins-SemiBold", size: 25))
                        
                        Spacer()
                        
                        NavigationLink {
                            SeeAll(movies: movieManager.topRatedMovies, title: "Top Rated")
                                
                        } label: {
                            Text("See All")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .hTrailing()
                        }
                        .foregroundStyle(.gray)
                    }
                    .padding(.bottom, -20)
                    
                    SmallTileView(movies: movieManager.topRatedMovies)
                        .padding(.horizontal, -30)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(K.Theme.black)
                
                // MARK: Now Playing
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Now")
                            .foregroundStyle(.brandOffWhite)
                            .font(Font.custom("Poppins-SemiBold", size: 25))
                        
                        Text("Playing")
                            .foregroundStyle(.gray)
                            .font(Font.custom("Poppins-SemiBold", size: 25))
                        
                        Spacer()
                        
                        NavigationLink {
                            SeeAll(movies: movieManager.nowPlayingMovies, title: "Now Playing")
                                //.navigationBarTitle("Now Playing", displayMode: .inline)
                        } label: {
                            Text("See All")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .hTrailing()
                        }
                        .foregroundStyle(.gray)
                    }
                    .padding(.bottom, -10)
                    
                    LongTileView(movies: movieManager.nowPlayingMovies)
                        .padding(.horizontal, -20)
                }
                .padding(.top, -10)
                .listRowSeparator(.hidden)
                .listRowBackground(K.Theme.black)
                
                // MARK: Popular Now
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Popular")
                            .foregroundStyle(.brandOffWhite)
                            .font(Font.custom("Poppins-SemiBold", size: 25))
                        
                        Text("Now")
                            .foregroundStyle(.gray)
                            .font(Font.custom("Poppins-SemiBold", size: 25))
                        
                        Spacer()
                        
                        NavigationLink {
                            SeeAll(movies: movieManager.popularMovies, title: "Popular")
                                //.navigationBarTitle("Popular", displayMode: .inline)
                        } label: {
                            Text("See All")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .hTrailing()
                        }
                        .foregroundStyle(.gray)
                    }
                    .padding(.bottom, -20)
                    
                    SmallTileView(movies: movieManager.popularMovies)
                        .padding(.horizontal, -30)
                }
                .padding(.bottom, 60)
                .padding(.vertical, -20)
                .listRowSeparator(.hidden)
                .listRowBackground(K.Theme.black)
            }
            .listStyle(.plain)
            .background(K.Theme.black)
            .listRowSeparator(.hidden)
            .scrollContentBackground(.hidden)
            //.navigationBarTitle("Movies", displayMode: .inline)
        }
        .task {
            await movieManager.getMovies(for: .trending)
            await movieManager.getMovies(for: .top_rated)
            await movieManager.getMovies(for: .now_playing)
            await movieManager.getMovies(for: .popular)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func GradientBlurView() -> some View {
        VStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movieManager.trendingMovies) { movie in
                        NavigationLink {
                            MovieDetail(movieId: movie.id, isActive: $isActive)
                        } label: {
                            MovieCardView(movie: movie)
                                .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 0, alignment: .center)
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.7)
                                        .blur(radius: phase.isIdentity ? 0 : 5)
                                        .offset(y: phase.isIdentity ? 0 : 150)
                                }
                        }
                        .isDetailLink(false)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .frame(height: 600)
    }
}

#Preview {
    HomeView()
}


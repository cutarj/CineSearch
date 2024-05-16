//
//  MovieDetail.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/23/24.
//

import SwiftUI
import AVKit

struct MovieDetail: View {
    
    @Binding var isActive: Bool
    
    @State private var movieId: Int
    @State private var isInFavorites = false
    @State private var isBackdropLoaded = false
    //@State private var isVideoLoading = false
    @State private var isFromSearch = false
    @State private var movieBackdrop: Image? = nil
    @ObservedObject private var movieManager = MovieManager()
    
    @Environment(\.dismiss) var dismiss
    
    // Video Player
    @State private var isPlaying = false
    
    // Key for UserDefaults
    private let recentSearchesKey = "recentSearches"
    
    init(movieId: Int, isActive: Binding<Bool>, isFromSearch: Bool? = false) {
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
        
        _movieId = State(initialValue: movieId)
        _isActive = isActive
        
        if let isFromSearch = isFromSearch {
            _isFromSearch = State(initialValue: isFromSearch)
        }
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView(showsIndicators: false) {
                
                ZStack(alignment: .top) {
                    
                    if movieManager.isLoading == false,
                       let movie = movieManager.movieDetails {
                        
                        // MARK: Blur Background Effect
                        GeometryReader { geometry in
                            
                            AsyncImage(url: movie.backdropURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .blur(radius: 15)
                                    .scaleEffect(1.5)
                                    .frame(width: geometry.size.width, height: 700)
                                    .overlay(
                                        LinearGradient(stops: [
                                            .init(color: .black, location: 0),
                                            .init(color: .black, location: 0.40),
                                            .init(color: .clear, location: 0.65),
                                            .init(color: .clear, location: 0.80)],
                                                       startPoint: .bottom, endPoint: .top)
                                        .frame(height: 1500)
                                    )
                                    .onAppear {
                                        movieBackdrop = image
                                        isBackdropLoaded = true
                                    }
                            } placeholder: {
                                SkeletonView()
                                    .padding(.top, getSafeArea().top + 50)
                                    .onAppear { isBackdropLoaded = false }
                            }
                            .edgesIgnoringSafeArea(.top)
                        }
                        .onAppear {
                            // MARK: Only add to RecentSearch if from SearchView()
                            if isFromSearch == true {
                                //saveRecentMovies(movie)
                                movieManager.saveRecentMovies(movie)
                            }
                        }
                        
                        // MARK: All Movie Details
                        if isBackdropLoaded == true {
                            DetailView(movie)
                        }
                    } else {
                        Text("No data found for movie.")
                            .hCenter()
                            .foregroundStyle(.white)
                    }
                }
                .zIndex(0)
            }
            .ignoresSafeArea()
            .foregroundStyle(.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Movie Details", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                    })
                    .padding(.leading, 15)
                }
            }
            .background(.black)
        }
        .onAppear {
            //movieManager.fetchMovieDetails(movieId)
            movieManager.startDataFetch(movieId)
        }
        .background(.black)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        //.navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Detail View
    func DetailView(_ movie: MovieDetails) -> some View {
        VStack(alignment: .center) {
            
            if isPlaying == false {
                
                if let movieBackdrop = self.movieBackdrop {
                    
                    // MARK: Backdrop Image
                    movieBackdrop
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 280)
                        .clipShape(.rect(cornerRadius: 25))
                        .overlay {
                            if movieManager.movieVideos.count > 0 {
                                VStack(alignment: .center) {
                                    Button {
                                        isPlaying.toggle()
                                    } label: {
                                        Image(systemName: "play.fill")
                                            .resizable()
                                            .padding(15)
                                            .padding(.leading, 2)
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .background(
                                                Circle()
                                                    .stroke(.white, lineWidth: 1.0)
                                                    .fill(.ultraThinMaterial)
                                                    .environment(\.colorScheme, .dark)
                                            )
                                    }
                                    
                                    Text("Watch Trailer")
                                        .hCenter()
                                        .padding(.top, 5)
                                        .font(Font.custom("Poppins-SemiBold", size: 15))
                                }
                            }
                        }
                } else {
                    ShimmerEffectBox()
                        .frame(width: 350, height: 280)
                        .clipShape(.rect(cornerRadius: 25))
                }
            } else {
                if let video = movieManager.movieVideos.first {
                    
                    PlayerView(videoKey: video.key)
                        .frame(width: 350, height: 280)
                        .clipShape(.rect(cornerRadius: 25))
                }
            }
            
            // MARK: Genres
            if let genres = movie.genres {
            //if !movie.genres?.isEmpty {
                Text(genres.map { $0.name }.joined(separator: " . "))
                    .hLeading()
                    .padding(.top, 5)
                    .padding(.leading, 20)
                    .font(Font.custom("Poppins-Medium", size: 15))
            }
            
            // MARK: Title
            Text(movie.title)
                .hLeading()
                .padding(.leading, 20)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.custom("Poppins-SemiBold", size: 25))
            
            HStack {
                // MARK: Release Date
                Text("\(movie.releaseDate.format("YYY"))")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .font(Font.custom("Poppins-SemiBold", size: 13))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.clear)
                            .stroke(.white, lineWidth: 1)
                    }
                
                // MARK: Runtime
                Text("\(movie.computedRuntime)")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .font(Font.custom("Poppins-SemiBold", size: 13))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.clear)
                            .stroke(.white, lineWidth: 1)
                    }
                
                // MARK: Original Country
                if let origin = movie.origin_country {
                    Text("\(origin.joined(separator: ", "))")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .font(Font.custom("Poppins-SemiBold", size: 13))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.clear)
                                .stroke(.white, lineWidth: 1)
                        }
                }
            }
            .hLeading()
            .padding(.top, -5)
            .padding(.leading, 20)
            
            // MARK: Overview
            Text(movie.overview)
                .hLeading()
                .padding(.top, 5)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.custom("Poppins-Regular", size: 13))
            
            // MARK: Add to Favorites Button
            //if movieManager.isMovieInFavorites(movie) {
            if isInFavorites == true {
                Button {
                    movieManager.removeMovieFromFavorites(movie)
                    isInFavorites.toggle()
                } label: {
                    Text("Added In Favorites")
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .frame(width: 350)
                        .foregroundColor(.white)
                        .background(.brandGray.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .font(Font.custom("Poppins-SemiBold", size: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.clear)
                                .stroke(.white, lineWidth: 1)
                        }
                }
                .padding(.top, 5)
            } else {
                Button {
                    movieManager.saveMovieToFavorites(movie)
                    isInFavorites.toggle()
                } label: {
                    Text("Add To Favorites")
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .frame(width: 350)
                        .font(Font.custom("Poppins-SemiBold", size: 15))
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.clear)
                                .stroke(.white, lineWidth: 1)
                        }
                }
                .padding(.top, 5)
            }
            
            //RatingView(movie)
            
            // MARK: Cast & Crew
            Text("Cast & Crew")
                .hLeading()
                .padding(.top, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .font(Font.custom("Poppins-Bold", size: 20))
            
            CastView(movieCast: movieManager.movieCast)
                .frame(height: movieManager.movieCast.count > 0 ? 155 : 50)
            
            // MARK: Video List
            Text("Videos")
                .hLeading()
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .font(Font.custom("Poppins-Bold", size: 20))
            
            VideoListView(videoList: movieManager.movieVideos)
                .frame(height: movieManager.movieVideos.count > 0 ? 225 : 50)
            
            // MARK: Recommendations
            Text("Recommendations")
                .hLeading()
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .font(Font.custom("Poppins-Bold", size: 20))
            
            RecommendationsView(recommendations: movieManager.movieRecos)
                .padding(.bottom, 100)  // Gap for floating tab bar
        }
        .zIndex(1)
        .padding(.top, getSafeArea().top + 50)
        .onAppear { isInFavorites = movieManager.isMovieInFavorites(movie) }
    }
}

#Preview {
    MovieDetail(movieId: 569094, isActive: .constant(false))
}

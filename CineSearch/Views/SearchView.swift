//
//  SearchView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/23/24.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var movies = [MovieDetails]()
    @State private var isActive: Bool = false
    @ObservedObject private var movieManager = MovieManager()
    
    
    @State private var showShimmer = true
    @State private var showPlaceholder = true
    
    // MARK: Search
    @State private var show = false
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var isFirstResponder: Bool = false
    @State private var searchScope = SearchScope.inbox
    
    // Key for UserDefaults
    private let recentSearchesKey = "recentSearches"
    
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
        
        UISearchBar.appearance().setImage(searchBarImage(), for: .search, state: .normal)
        UISearchBar.appearance().searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for movies, titles, and more",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(.white.opacity(0.8))]
        )
        UISearchBar.appearance().tintColor = UIColor(.white)
        UISearchBar.appearance().barTintColor = UIColor(named: "brandBlack")
        UISearchBar.appearance().backgroundColor = UIColor(named: "brandBlack")
    }
    
    private func fetchMovies() {
        if searchText.isEmpty {
            self.movies = movieManager.loadRecentMovies()
        } else {
            movieManager.searchMovies(searchText) { result in
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
        }
    }
    
    var searchResults: [MovieDetails] {
        if searchText.isEmpty {
            return self.movies
        } else {
            //return names.filter { $0.contains(searchText) }
            movieManager.searchMovies(searchText) { result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self.movies = movies
                    }
                case .failure(let error):
                    print("Error fetching movies: \(error)")
                }
            }
            return self.movies
        }
    }
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                
                if searchResults.count == 0 {
                    // MARK: Empty Recent Search
                    Text("No recent search.")
                        .hLeading()
                        .padding(.leading, 15)
                        .font(Font.custom("Poppins-SemiBold", size: 15))
                } else {
                    VStack {
                        
                        // MARK: Empty Recent Search
                        Text("Recently Search")
                            .hLeading()
                            .padding(.leading, 15)
                            .font(Font.custom("Poppins-SemiBold", size: 18))
                        
                        // MARK: Recent Searches
                        ForEach(searchResults, id: \.self) { movie in
                            ResultsView(movie: movie)
                                .padding(.horizontal)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(K.Theme.black)
                    }
                    .padding(.bottom, 70)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search for movies, titles, and more") {
                
                // MARK: Search Results
                ForEach(searchResults) { movie in
                    ResultsView(movie: movie)
                        .navigationBarBackButtonHidden(true)
                        .background(.brandBlack)
                        .listRowSeparator(.hidden)
                        .listRowBackground(K.Theme.black)
                }
                .navigationBarBackButtonHidden(true)
                .background(.brandBlack)
                .listRowSeparator(.hidden)
                .listRowBackground(K.Theme.black)
            }
            .tint(.brandOffWhite)
            .foregroundStyle(.brandOffWhite)
            .background(.brandBlack)
            .onSubmit(of: .search, fetchMovies)
            .onAppear(perform: fetchMovies)
            .onChange(of: searchText) {
                if searchText.isEmpty {
                    self.movies = movieManager.loadRecentMovies()
                }
            }
            .listRowSeparator(.hidden)
            .listRowBackground(K.Theme.black)
             //For testing purposes only
//            .onAppear {
//                let domain = Bundle.main.bundleIdentifier!
//                UserDefaults.standard.removePersistentDomain(forName: domain)
//                UserDefaults.standard.synchronize()
//            }
        }
        .background(.brandBlack)
        .navigationBarBackButtonHidden(true)
    }
 
    func ResultsView(movie: MovieDetails) -> some View {
        NavigationLink {
            MovieDetail(movieId: movie.id, isActive: $isActive, isFromSearch: true)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        } label: {
            HStack(alignment: .center) {
                AsyncImage(url: movie.posterURL500) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 180)
                        .clipShape(.rect(
                            topLeadingRadius: 15,
                            bottomLeadingRadius: 15
                        ))
                } placeholder: {
                    Image("poster")
                    //ShimmerEffectBox()
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 180)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                VStack(alignment: .leading) {
                    
                    // MARK: Genres
                    if let genres = movie.genres {
                        Text(genres.map { $0.name }.joined(separator: " . "))
                            .hLeading()
                            .padding(.top, 5)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(Font.custom("Poppins-Medium", size: 10))
                    }
                    
                    // MARK: Title
                    Text(movie.title)
                        .padding(.top, 3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.custom("Poppins-SemiBold", size: 15))
                    
                    HStack {
                        // MARK: Release Year
                        Text("\(movie.releaseDate.format("YYY"))")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .font(Font.custom("Poppins-SemiBold", size: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.clear)
                                    .stroke(.white, lineWidth: 1)
                            }
                        
                        // MARK: Runtime
                        if movie.computedRuntime != "" {
                            Text("\(movie.computedRuntime)")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .font(Font.custom("Poppins-SemiBold", size: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.clear)
                                        .stroke(.white, lineWidth: 1)
                                }
                        }
                        
                        // MARK: Original Country
                        if let origin = movie.origin_country {
                            Text("\(origin.joined(separator: ", "))")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .font(Font.custom("Poppins-SemiBold", size: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.clear)
                                        .stroke(.white, lineWidth: 1)
                                }
                        }
                    }
                    
                    // MARK: Release Date
                    Text(movie.releaseDate.format("MMMM dd, YYYY"))
                        .padding(.top, 1)
                        .font(Font.custom("Poppins-Regular", size: 12))
                }
                .hLeading()
                .padding(.leading, 2)
                .padding(.trailing, 10)
            }
            .background(.brandGray)
            .clipShape(.rect(cornerRadius: 15))
        }
        .isDetailLink(false)
    }
    
    private func searchBarImage() -> UIImage {
        let image = UIImage(systemName: "magnifyingglass")
        return image!.withTintColor(UIColor(.white.opacity(0.8)), renderingMode: .alwaysOriginal)
    }
}

#Preview {
    SearchView()
}

struct Message: Identifiable, Codable {
    let id: Int
    var user: String
    var text: String
}

enum SearchScope: String, CaseIterable {
    case inbox, favorites
}

//
//  MovieManager.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import Foundation
import RealmSwift
import Combine

class MovieManager: ObservableObject {
    
    // MARK: Home
    @Published var trendingMovies:      [Movie] = []
    @Published var popularMovies:       [Movie] = []
    @Published var nowPlayingMovies:    [Movie] = []
    @Published var latestMovies:        [Movie] = []
    @Published var topRatedMovies:      [Movie] = []
    @Published var upcomingMovies:      [Movie] = []
    
    // MARK: Movie Details
    @Published var movieDetails:        MovieDetails? = nil
    @Published var movieCast:           [MovieCast] = []
    @Published var movieCrew:           [MovieCrew] = []
    @Published var movieRecos:          [Recommendations] = []
    @Published var movieVideos:         [Videos] = []
    @Published var isLoading:           Bool = false
    @Published var isVideoLoading:      Bool = false
    
    // MARK: Userdefault keys
    private let favoritesKey = "favorites"
    private let recentSearchesKey = "recentSearches"
    
    var movieId: Int = 0
    
    // MARK: - Methods
    
    func searchMovies(_ searchText: String, completion: @escaping (Result<[MovieDetails], Error>) -> Void) {
        MovieAPICaller.searchMovies(query: searchText) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    @MainActor
    func getMovies(for category: MovieCategory) async {
        do {
            let movies = try await MovieAPICaller.getMovies(for: category)
            //DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            DispatchQueue.main.async {
                switch category {
                case .trending:
                    self.trendingMovies = movies
                case .popular:
                    self.popularMovies = movies
                case .now_playing:
                    self.nowPlayingMovies = movies
                case .latest:
                    self.latestMovies = movies
                case .top_rated:
                    self.topRatedMovies = movies
                case .upcoming:
                    self.upcomingMovies = movies.filter { movie in
                        let releaseDateString = movie.release_date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        guard let releaseDate = dateFormatter.date(from: releaseDateString) else {
                            return false
                        }
                        return releaseDate > Date()
                    }
                }
            }
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    func startDataFetch(_ movieId: Int) {
        isLoading = true
        isVideoLoading = true
        self.movieId = movieId
        
        let dispatchGroup = DispatchGroup()
        
        // Fetch movie details
        dispatchGroup.enter()
        print("Fetching movie details...")
        MovieAPICaller.getMovieDetails(movieId: movieId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.movieDetails = details
                case .failure(let error):
                    print("Error fetching movie details: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch movie credits
        dispatchGroup.enter()
        print("Fetching movie credits...")
        MovieAPICaller.getMovieCredit(movieId: movieId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.movieCast = result.cast
                    self.movieCrew = result.crew
                case .failure(let error):
                    print("Error fetching movie credits: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch movie recommendations
        dispatchGroup.enter()
        print("Fetching movie recommendations...")
        MovieAPICaller.getMovieReco(movieId: movieId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    self.movieRecos = result
                case .failure(let error):
                    print("Error fetching movie recommendations: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        // Fetch movie videos
        dispatchGroup.enter()
        print("Fetching movie videos...")
        MovieAPICaller.getMovieVideos(movieId: movieId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    self.movieVideos = video
                case .failure(let error):
                    print("Error fetching movie videos: \(error)")
                }
                self.isVideoLoading = false
                dispatchGroup.leave()
            }
        }
        
        // Completion handler for all requests
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
            print("All data fetched")
        }
    }
    
    // MARK: - Recent Searches
    
    func loadRecentMovies() -> [MovieDetails] {
        guard let savedData = UserDefaults.standard.data(forKey: recentSearchesKey) else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            let movies = try decoder.decode([MovieDetails].self, from: savedData)
            return movies
        } catch {
            print("Error decoding recent movies: \(error)")
            return []
        }
    }
    
    func saveRecentMovies(_ movie: MovieDetails) {
        // TODO: Add button to clear all recent searches
        var recentMovies = loadRecentMovies()
        
        // Check if the movie ID already exists and remove if true
        if let existingIndex = recentMovies.firstIndex(where: { $0.id == movie.id }) {
            recentMovies.remove(at: existingIndex)
        }
        
        recentMovies.insert(movie, at: 0)
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(recentMovies)
            UserDefaults.standard.set(encodedData, forKey: recentSearchesKey)
        } catch {
            print("Error encoding recent movies: \(error)")
        }
    }
    
    // MARK: - Favorites
    
    func loadFavorites() -> [MovieDetails] {
        guard let savedData = UserDefaults.standard.data(forKey: favoritesKey) else {
            return []
        }
        do {
            let decoder = JSONDecoder()
            let movies = try decoder.decode([MovieDetails].self, from: savedData)
            return movies
        } catch {
            print("Error decoding favorites movies: \(error)")
            return []
        }
    }
    
     func saveMovieToFavorites(_ movie: MovieDetails) {
        // TODO: Add button to clear all recent searches
        var favoriteMovies = loadFavorites()
        
        // Check if the movie ID already exists and remove if true
        if let existingIndex = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies.remove(at: existingIndex)
        }
        
        favoriteMovies.insert(movie, at: 0)
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(favoriteMovies)
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        } catch {
            print("Error encoding favorite movies: \(error)")
        }
    }
    
     func removeMovieFromFavorites(_ movie: MovieDetails) {
        var favoriteMovies = loadFavorites()
        
        // Check if the movie ID already exists and remove if true
        if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            favoriteMovies.remove(at: index)
        }
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(favoriteMovies)
            UserDefaults.standard.set(encodedData, forKey: favoritesKey)
        } catch {
            print("Error encoding favorite movies: \(error)")
        }
    }
    
    func isMovieInFavorites(_ movie: MovieDetails) -> Bool {
        var favoriteMovies = loadFavorites()
        
        // Check if the movie ID already exists and remove if true
        if let existingIndex = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Archive
    
//    func fetchMovieDetails(_ movieId: Int) {
//        MovieAPICaller.getMovieDetails(movieId: movieId) { result in
//            switch result {
//            case .success(let details):
//                self.movieDetails = details
//            case .failure(let error):
//                print("Error fetching movie details: \(error)")
//            }
//        }
//    }
//    func fetchMovieRecommendations(_ movieId: Int) {
//        MovieAPICaller.getMovieReco(movieId: movieId) { result in
//            switch result {
//            case .success(let recos):
//                self.movieRecos = recos
//            case .failure(let error):
//                print("Error fetching movie details: \(error)")
//            }
//        }
//    }
    
//    func getMovieDetails(_ id: Int) async {
//        do {
//            let movieDetails = try await MovieAPICaller.getDetails(for: id)
//            DispatchQueue.main.async {
//                self.movieDetails = movieDetails
//            }
//        } catch {
//            print("Error fetching movie details: \(error)")
//        }
//    }
    
//    func fetchMovieCredits(_ movieId: Int) {
//        MovieAPICaller.getMovieCredit(movieId: movieId) { result in
//            switch result {
//            case .success(let credit):
//                self.movieCrew = credit.crew
//                self.movieCast = credit.cast
//            case .failure(let error):
//                print("Error fetching movies: \(error)")
//            }
//        }
//    }
    
    func addMovie(_ movie: Movie) {
        let newMovie = MovieObject()
        newMovie.id = movie.id
        newMovie.backdropPath = movie.backdrop_path ?? ""
        newMovie.posterPath = movie.poster_path
        newMovie.title = movie.title
        newMovie.originalTitle = movie.original_title
        newMovie.overview = movie.overview
        newMovie.mediaType = movie.media_type ?? ""
        newMovie.isAdult = movie.adult
        newMovie.originalLanguage = movie.original_language
        newMovie.popularity = movie.popularity
        newMovie.releaseDate = movie.release_date
        newMovie.isVideo = movie.video
        newMovie.voteCount = movie.vote_count
        newMovie.voteAverage = movie.vote_average
        //$movieLists.append(newMovie)
        print("Realm: \(#function): movieName: \(movie.title)")
    }
    
}

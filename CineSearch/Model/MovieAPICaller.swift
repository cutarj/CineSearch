//
//  MovieAPICaller.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import Foundation
import Alamofire
import Combine

struct MovieAPICaller {
    
    static func getMovies(for category: MovieCategory) async throws -> [Movie] {
        guard let url = URL(string: category.endpointURL) else {
            throw NetworkError.urlError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.urlError
        }
        
        do {
            let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            return movieResponse.results
        } catch {
            throw NetworkError.canNotParseData
        }
    }
    
//    static func getMovieDetails(movieId: Int) async throws -> MovieDetails {
//        let urlString = NetworkConstant.shared.baseUrl + "/movie/" + "\(movieId)" + "?api_key=" + NetworkConstant.shared.apiKey
//        guard let url = URL(string: urlString) else {
//            throw NetworkError.urlError
//        }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            throw NetworkError.urlError
//        }
//        
//        do {
//            let details = try JSONDecoder().decode(MovieDetails.self, from: data)
//            return details
//        } catch {
//            throw NetworkError.canNotParseData
//        }
//    }
    
    static func searchMovies(query: String, completion: @escaping (Result<[MovieDetails], Error>) -> Void) {
        let url = URL(string: NetworkConstant.shared.baseUrl + "search/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: query),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(NetworkConstant.shared.bearerToken)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getMovieCredit(movieId: Int, completion: @escaping (Result<MovieCredit, Error>) -> Void) {
        let url = URL(string: NetworkConstant.shared.baseUrl + "movie/" + "\(movieId)" + "/credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(NetworkConstant.shared.bearerToken)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let credit = try JSONDecoder().decode(MovieCredit.self, from: data)
                completion(.success(credit))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let url = URL(string: NetworkConstant.shared.baseUrl + "/movie/" + "\(movieId)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(NetworkConstant.shared.bearerToken)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let details = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(.success(details))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getMovieReco(movieId: Int, completion: @escaping (Result<[Recommendations], Error>) -> Void) {
        let url = URL(string: NetworkConstant.shared.baseUrl + "/movie/" + "\(movieId)/recommendations")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(NetworkConstant.shared.bearerToken)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let recos = try JSONDecoder().decode(RecoResponse.self, from: data)
                completion(.success(recos.results))
                //let results = recos.results.compactMap { $0 }
                //if !results.isEmpty {
                //    completion(.success(results))
                //} else {
                //    print("No recommendations found")
                //    completion(.success([])) // Return an empty array if no recommendations are found
                //}
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getMovieVideos(movieId: Int, completion: @escaping (Result<[Videos], Error>) -> Void) {
        let url = URL(string: NetworkConstant.shared.baseUrl + "/movie/" + "\(movieId)/videos")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(NetworkConstant.shared.bearerToken)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Data Error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let recos = try JSONDecoder().decode(VideoResponse.self, from: data)
                completion(.success(recos.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func getDetails(for id: Int) async throws -> Movie {
        let urlString = NetworkConstant.shared.baseUrl + "movie/" + "\(id)?api_key=" + NetworkConstant.shared.apiKey
        guard let url = URL(string: urlString) else {
            throw NetworkError.urlError
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            return movie
        } catch {
            throw NetworkError.canNotParseData
        }
    }
}

enum APIResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

enum MovieCategory {
    case now_playing
    case trending
    case popular
    case latest
    case top_rated
    case upcoming
    //case search
    //case change_list
    
    var endpointURL: String {
        switch self {
        case .now_playing:
            return NetworkConstant.shared.baseUrl + "movie/now_playing?api_key=" + NetworkConstant.shared.apiKey
        case .trending:
            return NetworkConstant.shared.baseUrl + "trending/movie/day?api_key=" + NetworkConstant.shared.apiKey
        case .popular:
            return NetworkConstant.shared.baseUrl + "movie/popular?api_key=" + NetworkConstant.shared.apiKey
        case .latest:
            return NetworkConstant.shared.baseUrl + "movie/latest?api_key=" + NetworkConstant.shared.apiKey
        case .top_rated:
            return NetworkConstant.shared.baseUrl + "movie/top_rated?api_key=" + NetworkConstant.shared.apiKey
        case .upcoming:
            return NetworkConstant.shared.baseUrl + "movie/upcoming?api_key=" + NetworkConstant.shared.apiKey
        //case .search:
        //    return NetworkConstant.shared.baseUrl + "movie/search/movie?api_key=" + NetworkConstant.shared.apiKey
        //case .change_list:
        //    return NetworkConstant.shared.baseUrl + "movie/changes?api_key=" + NetworkConstant.shared.apiKey
        }
    }
}

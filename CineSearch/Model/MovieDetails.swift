//
//  MovieDetails.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import Foundation

struct MovieDetails: Codable, Identifiable, Hashable {
    
    static func == (lhs: MovieDetails, rhs: MovieDetails) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let adult: Bool
    let backdrop_path: String?
    let budget: Int?
    let genres: [Genres]?
    let media_type: String?
    let origin_country: [String]?
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let runtime: Int?
    let tagline: String?
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    var runtimeString: String {
        if let runtime = runtime {
            return String(runtime) + "m"
        } else {
            return ""
        }
    }
    
    var releaseDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: release_date) ?? Date()
    }
    
    var computedRuntime: String {
        guard let runtime = runtime else { return "" }
        let hours = runtime / 60
        let remainingMinutes = runtime % 60
        
        if hours == 0 {
            return "\(remainingMinutes)mins"
        } else if remainingMinutes == 0 {
            return "\(hours)hr"
        } else {
            return "\(hours)hr \(remainingMinutes)mins"
        }
    }
    
    //var backdropURL500: URL {
    //    return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path)")!
    //}
    
    var backdropURL500: URL {
        if let backdrop = backdrop_path {
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop)")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path )")!
        }
    }
    
    //var backdropURL: URL {
    //    return URL(string: "https://image.tmdb.org/t/p/original\(backdrop_path)")!
    //}
    
    var backdropURL: URL {
        if let backdrop = backdrop_path {
            return URL(string: "https://image.tmdb.org/t/p/original\(backdrop)")!
        } else if let poster = poster_path, !poster.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/original\(poster)")!
        } else {
            //return URL(string: "https://placehold.jp/350x280.png")!
            return URL(string: "https://placehold.jp/20/1a1a1a/c2c2c2/350x280.png?text=\(title)")!
        }
    }
    
    var posterURL500: URL {
        if let poster = poster_path, !poster.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/w500\(poster)")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path)")!
        }
    }
    
    var posterURL: URL {
        if let poster = poster_path, !poster.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/original\(poster)")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/original\(backdrop_path)")!
        }
    }
}

struct Genres: Codable, Identifiable {
    let id: Int
    let name: String
}

struct MovieCredit: Decodable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String
    let profile_path: String?
    
    var profileURL: URL {
        if let profile = profile_path, profile != "" {
            return URL(string: "https://image.tmdb.org/t/p/original\(profile)")!
        } else {
            return URL(string: "https://placehold.jp/10/1a1a1a/c2c2c2/100x100.png?text=\(name)")!
        }
    }
}

struct MovieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}

struct SearchResponse: Codable {
    let results: [MovieDetails]
}

// MARK: - Recommendations Model

struct Recommendations: Decodable, Identifiable {
    
    let id: Int
    let backdrop_path: String?
    let original_title: String
    let overview: String
    let poster_path: String?
    let media_type: String
    let title: String
    let original_language: String
    let genre_ids: [Int]?
    let release_date: String
    
    var genreNames: [String] {
        guard let genreIds = genre_ids else { return [] }
        return genreIds.compactMap { genreMap[$0] }
    }
    
    //var posterURL: URL {
    //    return URL(string: "https://image.tmdb.org/t/p/original\(poster_path)")!
    //}
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/original\(poster_path ?? "https://placehold.jp/170x230.png")")!
    }
}

struct RecoResponse: Decodable {
    //let results: [Recommendations?]
    let results: [Recommendations]
}

// MARK: - Videos Model

struct Videos: Decodable, Identifiable {
    
    let id: String
    let name: String
    let key: String
    let site: String
    let type: String
}

struct VideoResponse: Decodable {
    let results: [Videos]
}

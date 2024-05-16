//
//  MovieModel.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import Foundation

struct Movie: Codable, Identifiable, Hashable {
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let adult: Bool
    let backdrop_path: String?
    let title: String
    let original_title: String
    let overview: String
    let poster_path: String
    let media_type: String?
    let original_language: String
    let popularity: Double
    let release_date: String
    let video: Bool
    let vote_count: Int
    let vote_average: Double
    let genre_ids: [Int]?
    let runtime: Int?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
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
        guard let runtime = runtime else {
            return ""
        }
        
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
    
    var genreNames: [String] {
        guard let genreIds = genre_ids else { return [] }
        return genreIds.compactMap { genreMap[$0] }
    }
    
    var backdropURL500: URL {
        if let backdrop = backdrop_path, backdrop.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path )")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path)")!
        }
    }
    
    var backdropURL: URL {
        if let backdrop = backdrop_path, backdrop.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/original\(poster_path )")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/original\(backdrop_path)")!
        }
    }
    
    var posterURL500: URL {
        if poster_path.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path ?? "")")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")!
        }
    }
    
    var posterURL: URL {
        if poster_path.isEmpty {
            return URL(string: "https://image.tmdb.org/t/p/original\(backdrop_path ?? "")")!
        } else {
            return URL(string: "https://image.tmdb.org/t/p/original\(poster_path)")!
        }
    }
}

struct MovieResponse: Codable {
    let page: Int?
    let results: [Movie]
}

let genreMap: [Int: String] = [
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western"
]

struct MovieVideoResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}

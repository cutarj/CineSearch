//
//  MovieObject.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 4/22/24.
//

import Foundation
import RealmSwift

class MovieObject: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: Int
    @Persisted var backdropPath: String
    @Persisted var posterPath: String
    @Persisted var title: String
    @Persisted var originalTitle: String
    @Persisted var overview: String
    @Persisted var mediaType: String
    @Persisted var isAdult: Bool
    @Persisted var originalLanguage: String
    @Persisted var popularity: Double
    @Persisted var releaseDate: String
    @Persisted var isVideo: Bool
    @Persisted var voteCount: Int
    @Persisted var voteAverage: Double
}

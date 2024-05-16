//
//  NetworkConstant.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import Foundation

class NetworkConstant {
    
    public static var shared: NetworkConstant = NetworkConstant()
    
    private init() {
        //Singletone
    }
    
    public var apiKey: String {
        get {
            return "65baa7735f544abd0bcd2c4a8d7dce08"
        }
    }
    public var bearerToken: String {
        get {
            return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NWJhYTc3MzVmNTQ0YWJkMGJjZDJjNGE4ZDdkY2UwOCIsInN1YiI6IjY0MWQ2MzhmZTBlYzUxMDBlNGFkNWYzOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.If9wYp6aJlk-HPoxpXhIPMCGMR4uPi9AxosOmCKDZKI"
        }
    }
    
    public var baseUrl: String {
        get {
            return "https://api.themoviedb.org/3/"
        }
    }
    
    public var imageBaseUrl: String {
        get {
            return "https://image.tmdb.org/t/p/w500/"
        }
    }
}

enum NetworkError: Error {
    case urlError
    case canNotParseData
}

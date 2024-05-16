//
//  MovieDetailsView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 2/29/2023.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie

    var body: some View {
        VStack {
            VStack {
                    
                // MARK: Title
                Text(movie.title)
                    .hLeading()
                    .lineLimit(2)
                    .padding(.bottom, 3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.custom("Poppins-Bold", size: 16))
                
                HStack(spacing: 10) {
                    // MARK: Genres and Release Date
                    Text(movie.genreNames.joined(separator: " . ") + " -- \(movie.releaseDate.format("MMMM dd, YYYY"))")
                        .hLeading()
                        .lineLimit(1)
                        .font(Font.custom("Poppins-SemiBold", size: 11))
                }
            }
            .hCenter()
            .foregroundStyle(.white)
            .padding(.bottom, 2)
            
            // MARK: Overview
            Text(movie.overview)
                .hLeading()
                .font(.caption2)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.white.opacity(0.8))
        }
    }
}

#Preview {
    //MovieDetailsView(movie: movies[0])
    MovieDetailsView(movie: Movie(
        id: 001,
        adult: true,
        backdrop_path: "https://image.tmdb.org/t/p/original/sI6uCeF8mUlZx22mFfHSi9W3XQ9.jpg",
        title: "The Idea of You",
        original_title: "The Idea of You",
        overview: "40-year-old single mom Solène begins an unexpected romance with 24-year-old Hayes Campbell, the lead singer of August Moon, the hottest boy band on the planet.",
        poster_path: "https://image.tmdb.org/t/p/original/zDi2U7WYkdIoGYHcYbM9X5yReVD.jpg",
        media_type: "The Idea of You",
        original_language: "en",
        popularity: 100.0,
        release_date: "2024-05-02",
        video: false,
        vote_count: 508,
        vote_average: 7.573,
        genre_ids: [0, 1],
        runtime: 130))
}

extension Text {
    func getContrastText(backgroundColor: Color) -> some View {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.6 ? self.foregroundColor(.white) : self.foregroundColor(.black)
    }
}

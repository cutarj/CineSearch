//
//  MovieCardView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 2/29/2023.
//

import SwiftUI

struct ShowDetailsModifier: ViewModifier {
    @Binding var isShowDetails: Bool

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topTrailing) {
                DetailsButton(isShowDetails: $isShowDetails)
                    .padding()
            }
    }
}

extension View {
    func withDetailsButton(_ isShowDetails: Binding<Bool>) -> some View {
        modifier(ShowDetailsModifier(isShowDetails: isShowDetails))
    }
}

struct MovieCardView: View {
    let movie: Movie
    @State private var isShowDetails: Bool = true
    
    let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .black, location: 0),
                .init(color: .black, location: 0.75),
                .init(color: .clear, location: 0.75),
                .init(color: .clear, location: 0.90)
            ]),
            startPoint: .top,
            endPoint: .bottom
    )

    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                ZStack {
                    
                    // MARK: Poster Image
                    AsyncImage(url: movie.posterURL) { image in
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .zIndex(0)
                            .withDetailsButton($isShowDetails)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.gray, lineWidth: 2)
                            )
                    } placeholder: {
                        ShimmerEffectBox()
                            .clipShape(.rect(cornerRadius: 15))
                    }

                    if isShowDetails {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .clipShape(.rect(cornerRadius: 20))
                            .zIndex(1)
                        
                        // MARK: Poster Image
                        AsyncImage(url: movie.posterURL) { image in
                            image
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.gray, lineWidth: 1)
                                )
                        } placeholder: {
                            ShimmerEffectBox()
                                .clipShape(.rect(cornerRadius: 15))
                        }
                        //.mask(gradient)
                        .zIndex(2)
                        .withDetailsButton($isShowDetails)
                        .overlay(alignment: .bottom) {
                            // MARK: Movie Details
                            MovieDetailsView(movie: movie)
                                .padding()
                                .padding(.bottom, -2)
                                .background(.ultraThinMaterial)
                                .clipShape(.rect(
                                    bottomLeadingRadius: 20,
                                    bottomTrailingRadius: 20
                                ))
                                .environment(\.colorScheme, .dark)
                        }
                    }
                }
                .frame(width: 350, height: 520)
                .padding()
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 20)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

#Preview {
    //MovieCardView(movie: movies[2])
    MovieCardView(movie: Movie(
        id: 001,
        adult: true,
        backdrop_path: "https://image.tmdb.org/t/p/original/sI6uCeF8mUlZx22mFfHSi9W3XQ9.jpg",
        title: "The Idea of You",
        original_title: "The Idea of You",
        overview: "40-year-old single mom Solène begins an unexpected romance with 24-year-old Hayes Campbell, the lead singer of August Moon, the hottest boy band on the planet.40-year-old single mom Solène begins an unexpected romance with 24-year-old Hayes Campbell, the lead singer of August Moon, the hottest boy band on the planet.40-year-old single mom Solène begins an unexpected romance with 24-year-old Hayes Campbell, the lead singer of August Moon, the hottest boy band on the planet.40-year-old single mom Solène begins an unexpected romance with 24-year-old Hayes Campbell, the lead singer of August Moon, the hottest boy band on the planet.40-year-old single mom Solène begins an unexpected romance with 24-year-old Hayes Campbell, the lead singer of August Moon, the hottest boy band on the planet.",
        poster_path: "https://image.tmdb.org/t/p/original/zDi2U7WYkdIoGYHcYbM9X5yReVD.jpg",
        media_type: "The Idea of You",
        original_language: "en",
        popularity: 100.0,
        release_date: "2024-05-02",
        video: false,
        vote_count: 508,
        vote_average: 7.573,
        genre_ids: [28, 878],
        runtime: 130))
}

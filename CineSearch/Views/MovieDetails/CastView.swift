//
//  CastView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/24/24.
//

import SwiftUI

struct CastView: View {
    
    var movieCast: [MovieCast]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(alignment: .top) {
                
                if movieCast.count > 0 {
                    
                    ForEach(movieCast) { cast in
                        
                        LazyVStack(alignment: .leading) {
                            
                            // MARK: Cast Image
                            AsyncImage(url: cast.profileURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                Image("user")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            // MARK: Cast Name
                            Text(cast.name)
                                .hLeading()
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.brandOffWhite)
                                .font(Font.custom("Poppins-SemiBold", size: 13))
                            
                            // MARK: Cast Character
                            Text("\"\(cast.character)\"")
                                .hLeading()
                                //.padding(.top, 0.5)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 100)
                                .lineLimit(2)
                                .scaledToFill()
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.brandOffWhite)
                                .font(Font.custom("Poppins-Thin", size: 12))
                            
                        }
                        .hLeading()
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                        .padding(.trailing, -20)
                    }
                    
                } else {
                    
                    Text("No cast available.")
                        .hLeading()
                        .padding(.leading, 10)
                        .foregroundColor(.brandOffWhite)
                        .font(Font.custom("Poppins-Regular", size: 15))
                        .italic()
                }
            }
        }
        .background(.black)
        .padding(.top, -5)
        .padding(.leading, 5)
    }
}

#Preview {
    CastView(movieCast: [
        MovieCast(id: 10859, name: "Ryan Reynolds", character: "Wade Wilson / Deadpool", profile_path: "/so89QyuxAZY8IOpNTweCekhxsvO.jpg"),
        MovieCast(id: 6968, name: "Hugh Jackman", character: "Logan / Wolverine", profile_path: "/4Xujtewxqt6aU0Y81tsS9gkjizk.jpg")
    ])
//    CastView(movieCast: MovieDetails(
//        id: 573436,
//        adult: false,
//        backdrop_path: "/4HodYYKEIsGOdinkGi2Ucz6X9i0.jpg",
//        budget: 100000000,
//        genres: [
//            Genres(id: 16, name: "Animation"),
//            Genres(id: 28, name: "Action"),
//            Genres(id: 12, name: "Adventure"),
//            Genres(id: 878, name: "Science Fiction")
//        ],
//        media_type: "",
//        origin_country: ["US"],
//        original_language: "en",
//        original_title: "Spider-Man: Across the Spider-Verse",
//        overview: "After reuniting with Gwen Stacy, Brooklyn’s full-time, friendly neighborhood Spider-Man is catapulted across the Multiverse, where he encounters the Spider Society, a team of Spider-People charged with protecting the Multiverse’s very existence. But when the heroes clash on how to handle a new threat, Miles finds himself pitted against the other Spiders and must set out on his own to save those he loves most.",
//        popularity: 233.552,
//        poster_path: "/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg",
//        release_date: "2023-05-31",
//        runtime: 140,
//        tagline: "It's how you wear the mask that matters.",
//        title: "Spider-Man: Across the Spider-Verse",
//        video: false,
//        vote_average: 8.4,
//        vote_count: 6259))
}



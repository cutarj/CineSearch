//
//  RecommendationsView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/24/24.
//

import SwiftUI

struct RecommendationsView: View {
    
    var recommendations: [Recommendations]
    @State private var isActive: Bool = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                
            LazyHStack(alignment: .top) {
                
                if recommendations.count > 0 {
                    ForEach(recommendations) { reco in
                        
                        VStack(alignment: .leading) {
                            
                            NavigationLink {
                                MovieDetail(movieId: reco.id, isActive: $isActive)
                            } label: {
                                VStack(alignment: .leading) {
                                    
                                    AsyncImage(url: reco.posterURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 170, height: 230)
                                                .clipShape(.rect(cornerRadius: 10))
                                        } placeholder: {
                                            ShimmerEffectBox()
                                                .frame(width: 170, height: 230)
                                                .clipShape(.rect(cornerRadius: 10))
                                        }
                                    
                                    // MARK: Movie Title
                                    Text(reco.title)
                                        .hLeading()
                                        .frame(width: 170)
                                        .foregroundColor(.brandOffWhite)
                                        .multilineTextAlignment(.leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(Font.custom("Poppins-SemiBold", size: 15))
                                }
                                .hLeading()
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                                .padding(.trailing, -20)
                            }
                        }
                        .padding(.trailing, -10)
                    }
                } else {
                    Text("No recommendations available.")
                        .hLeading()
                        .padding(.leading, 20)
                        .foregroundColor(.brandOffWhite)
                        .font(Font.custom("Poppins-Regular", size: 15))
                        .italic()
                    
                }
            }
        }
        .background(.black)
        .padding(.top, -5)
    }
}

#Preview {
    RecommendationsView(recommendations: [
        Recommendations(id: 324857,
                        backdrop_path: "/b9YkKJcW3pPaXgMZu9uoT7v9yRB.jpg",
                        original_title: "Spider-Man: Into the Spider-Verse",
                        overview: "Struggling to find his place in the world while juggling school and family, Brooklyn teenager Miles Morales is unexpectedly bitten by a radioactive spider and develops unfathomable powers just like the one and only Spider-Man. While wrestling with the implications of his new abilities, Miles discovers a super collider created by the madman Wilson \"Kingpin\" Fisk, causing others from across the Spider-Verse to be inadvertently transported to his dimension.",
                        poster_path: "/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg",
                        media_type: "movie",
                        title: "Spider-Man: Into the Spider-Verse",
                        original_language: "en",
                        genre_ids: [16, 28, 12, 878],
                        release_date: "2018-12-06"),
        Recommendations(id: 298618,
                        backdrop_path: "/yF1eOkaYvwiORauRCPWznV9xVvi.jpg",
                        original_title: "The Flash",
                        overview: "When his attempt to save his family inadvertently alters the future, Barry Allen becomes trapped in a reality in which General Zod has returned and there are no Super Heroes to turn to. In order to save the world that he is in and return to the future that he knows, Barry's only hope is to race for his life. But will making the ultimate sacrifice be enough to reset the universe?",
                        poster_path: "/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg",
                        media_type: "movie",
                        title: "The Flash",
                        original_language: "en",
                        genre_ids: [28, 12, 878],
                        release_date: "2023-06-13")
    ])
}

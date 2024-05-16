//
//  VerticalTileView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct VerticalTileView: View {
    
    var movies: [Movie]
    @State private var isActive: Bool = false
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 5) {
            
            ForEach(movies) { movie in
                
                NavigationLink {
                    MovieDetail(movieId: movie.id, isActive: $isActive)
                } label: {
                    VStack {
                        AsyncImage(url: movie.posterURL500) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 190, alignment: .center)
                                .clipShape(.rect(cornerRadius: 10))
                        } placeholder: {
                            ShimmerEffectBox()
                                .clipShape(.rect(cornerRadius: 10))
                                .frame(width: 120, height: 190, alignment: .center)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 5)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    VerticalTileView(movies: [Movie]())
}

//struct VerticalTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleCards = [
//            HeaderCard(movieId: 934632, title: "Rebel Moon - Part Two: The Scargiver", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/w500/mcymlABFPpV2kblqrpmySoVsGVO.jpg")!),
//            HeaderCard(movieId: 934632, title: "Immaculate", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/pIFGZRCWjdQwECoXcphCCe1tl0B.jpg")!),
//            HeaderCard(movieId: 934632, title: "Dune", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/d5NXSklXo0qyIYkgV94XAgMIckC.jpg")!),
//            HeaderCard(movieId: 934632, title: "Dune", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/d5NXSklXo0qyIYkgV94XAgMIckC.jpg")!)
//        ]
//        
//        return VerticalTileView(cards: sampleCards)
//    }
//}

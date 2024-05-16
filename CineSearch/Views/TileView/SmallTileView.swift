//
//  SmallTileView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct SmallTileView: View {
    
    var movies: [Movie]
    @State private var isActive: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                let size = geometry.size
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        
                        ForEach(movies) { movie in
                            
                            NavigationLink {
                                MovieDetail(movieId: movie.id, isActive: $isActive)
                            } label: {
                                VStack(alignment: .leading) {
                                    AsyncImage(url: movie.posterURL500) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 180, height: 180, alignment: .center)
                                            .clipShape(.rect(cornerRadius: 15))
                                            .overlay {
                                                OverlayView(title: movie.title)
                                            }
                                            .clipShape(.rect(cornerRadius: 15))
                                            .shadow(color: .black.opacity(0.25),radius: 5,x: 5, y: 5)
                                    } placeholder: {
                                        ShimmerEffectBox()
                                            .clipShape(.rect(cornerRadius: 15))
                                            .frame(width: 180, height: 180, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal,30)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .center)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            })
            .frame(height: 240, alignment: .center)
        }
    }
    
    @ViewBuilder
    func OverlayView(title: String) -> some View {
        ZStack(alignment:
                .bottomLeading, content: {
                    LinearGradient (colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .black.opacity(0.1),
                        .black.opacity (0.5),
                        .black],
                                    startPoint: .top, endPoint: .bottom)
                    VStack(alignment: .leading, spacing: 4,content:{
                        Text (title)
                            .font(.subheadline)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                    })
                    .padding(10)
                })
    }
}

//struct SmallTileView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleCards = [
//            HeaderCard(movieId: 934632, title: "Rebel Moon - Part Two: The Scargiver", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/w500/mcymlABFPpV2kblqrpmySoVsGVO.jpg")!),
//            HeaderCard(movieId: 934632, title: "Immaculate", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/pIFGZRCWjdQwECoXcphCCe1tl0B.jpg")!),
//            HeaderCard(movieId: 934632, title: "Dune", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/d5NXSklXo0qyIYkgV94XAgMIckC.jpg")!)
//        ]
//        
//        return SmallTileView(cards: sampleCards)
//    }
//}

#Preview {
    SmallTileView(movies: [Movie]())
}

//
//  LongTileView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct LongTileView: View {
    
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
                                            .frame(width: 220, height: 320, alignment: .center)
                                            .clipShape(.rect(cornerRadius: 15))
                                            .shadow(color: .black.opacity(0.25),radius: 5,x: 5, y: 5)
                                    } placeholder: {
                                        ShimmerEffectBox()
                                            .clipShape(.rect(cornerRadius: 15))
                                            .frame(width: 200, height: 350, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal,20)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .center)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            })
            .frame(height: 350, alignment: .center)
        }
    }
}

#Preview {
    LongTileView(movies: [Movie]())
}

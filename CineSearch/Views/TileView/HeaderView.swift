//
//  HeaderView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct HeaderView: View {
    
    var headerCards: [HeaderCard]
    
    @State private var selectedId = 0
    @State private var isPresented = false
    @State private var isLoading = false
    
    @GestureState private var isDetectingPress = false
    @ObservedObject private var movieManager = MovieManager()
    
    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                let size = geometry.size
                ScrollView(.horizontal){
                    HStack(spacing: 5){
                        ForEach(headerCards) { card in
                            GeometryReader(content: { proxy in
                                let cardSize = proxy.size
                                let minX = min(proxy.frame(in: .scrollView).minX * 1.4, proxy.size.width * 1.4)
                                AsyncImage(url: card.image) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .scaleEffect(1.25)
                                        .offset(x: -minX)
                                        .frame(width: cardSize.width, height: cardSize.height, alignment: .center)
                                        .overlay {
                                            OverlayView(card: card)
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y:10)
                                } placeholder: {
                                    ShimmerEffectBox()
                                        .clipShape(.rect(cornerRadius: 15))
                                        .frame(width: cardSize.width, height: cardSize.height, alignment: .center)
                                }
                            })
                            .frame(width: size.width - 60, height: size.height - 50, alignment: .center)
                            .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                view.scaleEffect(phase.isIdentity ? 1 : 0.95)
                            }
                            .onTapGesture {
                                selectedId = card.movieId
                            }
                        }
                    }
                    .padding(.horizontal,30)
                    .scrollTargetLayout()
                    .frame(height: size.height,alignment: .top)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            })
            .frame(width: 400, height: 450)
            .padding(.horizontal,-15)
            .padding(.top, 10)
        }
        .padding(15)
        .onChange(of: selectedId) {
            isPresented = selectedId != 0
            Task {
                //await movieManager.getMovieDetails(selectedId)
                isLoading = false
            }
        }
    }
    
    @ViewBuilder
    func OverlayView(card: HeaderCard) -> some View {
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
                        Text (card.title)
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                        Text (card.date)
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.8))
                    })
                    .padding(20)
                })
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleHeaderCards = [
            HeaderCard(movieId: 934632, title: "Rebel Moon - Part Two: The Scargiver", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/mcymlABFPpV2kblqrpmySoVsGVO.jpg")!),
            HeaderCard(movieId: 934632, title: "Immaculate", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/pIFGZRCWjdQwECoXcphCCe1tl0B.jpg")!),
            HeaderCard(movieId: 934632, title: "Dune", date: "April 19, 2024", image: URL(string: "https://image.tmdb.org/t/p/original/d5NXSklXo0qyIYkgV94XAgMIckC.jpg")!)
        ]
        
        return HeaderView(headerCards: sampleHeaderCards)
    }
}

struct HeaderCard: Identifiable, Hashable {
    var id: UUID = .init()
    var movieId: Int
    var title: String
    var date: String
    //var image: String
    var image: URL
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .resizable()
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}

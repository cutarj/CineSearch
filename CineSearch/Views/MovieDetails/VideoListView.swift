//
//  VideoListView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/24/24.
//

import SwiftUI

struct VideoListView: View {
    
    var videoList: [Videos]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                
            LazyHStack(alignment: .top) {
                
                if videoList.count > 0 {
                    ForEach(videoList) { video in
                        
                        VideoItemView(video: video)
                            .padding(.horizontal)
                    }
                } else {
                    Text("No videos available.")
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

struct VideoItemView: View {
    
    var video: Videos
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: Custom Player View
            PlayerView(videoKey: video.key)
                .frame(width: 320, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // MARK: Video Name / Title
            Text(video.name)
                .hLeading()
                .frame(width: 320)
                .foregroundColor(.brandOffWhite)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .font(Font.custom("Poppins-SemiBold", size: 15))
        }
        .padding(.trailing, -20)
    }
}

#Preview {
    VideoListView(videoList: [
        Videos(id: "660431f8b02f5e017d226cf7", name: "THE SPIDER WITHIN: A SPIDER-VERSE STORY | Official Short Film (Full)", key: "AFPLRIdn1pk", site: "YouTube", type: "Featurette"),
        Videos(id: "65e8c85463e6fb01853667d6", name: "Drawn To The Moment | Joaquim Dos Santos & Justin K. Thompson", key: "qA8JVcRUnCg", site: "YouTube", type: "Featurette")
    ])
}

//
//  PlayerView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/24/24.
//

import AVKit
import WebKit
import SwiftUI

struct PlayerView: View {
    
    var videoKey: String
    
    var body: some View {
        VStack {
            YouTubeView(videoID: videoKey)
        }
        .background(.red)
    }
}

#Preview {
    PlayerView(videoKey: "AFPLRIdn1pk")
}

struct YouTubeView: UIViewRepresentable {
    
    let videoID: String
    
    func makeUIView(context: Context) ->  WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        //config.mediaTypesRequiringUserActionForPlayback = []
        return WKWebView(frame: .zero, configuration: config)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}

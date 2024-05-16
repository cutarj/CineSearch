//
//  SkeletonView.swift
//  CineSearch
//
//  Created by Junalyn Cutar on 1/22/24.
//

import SwiftUI

struct SkeletonView: View {
    var body: some View {
        ZStack {
            
            Color(.black)
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                
                ShimmerEffectBox()
                    .frame(width: 350, height: 280)
                    .clipShape(.rect(cornerRadius: 25))
                    
                ShimmerEffectBox()
                    .frame(width: 350, height: 100)
                    .clipShape(.rect(cornerRadius: 25))
                
                HStack {
                    
                    ShimmerEffectBox()
                        .frame(width: 100, height: 50)
                        .clipShape(.rect(cornerRadius: 25))
                    
                    ShimmerEffectBox()
                        .frame(width: 100, height: 50)
                        .clipShape(.rect(cornerRadius: 25))
                    
                    ShimmerEffectBox()
                        .frame(width: 100, height: 50)
                        .clipShape(.rect(cornerRadius: 25))
                }
                
                ShimmerEffectBox()
                    .frame(width: 350, height: 280)
                    .clipShape(.rect(cornerRadius: 25))
            }
        }
    }
}

#Preview {
    SkeletonView()
}

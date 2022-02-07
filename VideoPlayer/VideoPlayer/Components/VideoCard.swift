//
//  VideoCard.swift
//  VideoPlayer
//
//  Created by Andrew Hoang on 2/6/22.
//

import SwiftUI

struct VideoCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "")) { image in
                
            } placeholder: {
                Rectangle()
                
            }
        }
        
    }
}

struct VideoCard_Previews: PreviewProvider {
    static var previews: some View {
        VideoCard()
    }
}

//
//  RemoteImageView.swift
//  Teebay
//
//  Created by Promal on 16/6/25.
//

import CachedAsyncImage
import SwiftUI

//Add dependency https://github.com/lorenzofiamingo/swiftui-cached-async-image.git
struct RemoteImageView: View {
    private let url: URL?
    init(url: URL?) {
        self.url = url
    }
    var body: some View {
        ZStack {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50, maxHeight: 50)
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .foregroundColor(.secondary)
            }
        }
    }
}

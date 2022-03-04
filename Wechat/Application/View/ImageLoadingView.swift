//
//  ImageLoadingView.swift
//  Wechat
//
//  Created by Jian on 2022/3/1.
//

import SwiftUI

struct ImageLoadingView: View {
    private let placeholderImageName: String
    private let url: URL?
    private let width: CGFloat?
    private let height: CGFloat?
    
    init(placeholderImageName: String, url: URL?, width: CGFloat?, height: CGFloat?) {
        self.placeholderImageName = placeholderImageName
        self.url = url
        self.width = width
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: url) { image in
            if let width = width, let height = height {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
            } else {
                if let width = width {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: width)
                }
                if let height = height {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: height)
                }
            }
        } placeholder: {
            ZStack {
                if let width = width, let height = height {
                    Image(placeholderImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                } else {
                    if let width = width {
                        Image(placeholderImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: width)
                    }
                    if let height = height {
                        Image(placeholderImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: height)
                    }
                }
                ProgressView()
            }
        }
        .clipped()
    }
}

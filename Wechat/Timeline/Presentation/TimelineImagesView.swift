//
//  TimelineImagesView.swift
//  Wechat
//
//  Created by Jian on 2022/3/3.
//

import SwiftUI

struct TimelineImagesView: View {
    @State private var urls: [URL]
    
    init(urls: [URL]) {
        _urls = .init(wrappedValue: urls)
    }
    
    var body: some View {
        if urls.count == 1 {
            TimelineSingleImageView(url: urls.first!)
        }
        if urls.count == 4 {
            TimelineFourImagesView(urls: urls)
        }
        if urls.count != 1 && urls.count != 4 {
            TimelineNineImagesView(urls: urls)
        }
    }
}

struct TimelineSingleImageView: View {
    @State private var url: URL
    
    init(url: URL) {
        _url = .init(wrappedValue: url)
    }
    
    var body: some View {
        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                         url: url,
                         width: 150,
                         height: 220)
    }
}

struct TimelineFourImagesView: View {
    @State private var urls: [URL]
    private let boxSize: CGFloat = 70
    
    init(urls: [URL]) {
        _urls = .init(wrappedValue: urls)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if urls.count > 0 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[0],
                                     width: boxSize,
                                     height: boxSize)
                }
                if urls.count > 1 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[1],
                                     width: boxSize,
                                     height: boxSize)
                }
            }
            HStack(alignment: .top) {
                if urls.count > 2 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[2],
                                     width: boxSize,
                                     height: boxSize)
                }
                if urls.count > 3 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[3],
                                     width: boxSize,
                                     height: boxSize)
                }
            }
        }
    }
}

struct TimelineNineImagesView: View {
    @State private var urls: [URL]
    private let boxSize: CGFloat = 70
    
    init(urls: [URL]) {
        _urls = .init(wrappedValue: urls)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if urls.count > 0 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[0],
                                     width: boxSize,
                                     height: boxSize)
                }
                if urls.count > 1 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[1],
                                     width: boxSize,
                                     height: boxSize)
                }
                if urls.count > 2 {
                    ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                     url: urls[2],
                                     width: boxSize,
                                     height: boxSize)
                }
            }
            if urls.count > 3 {
                HStack(alignment: .top) {
                    if urls.count > 3 {
                        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                         url: urls[3],
                                         width: boxSize,
                                         height: boxSize)
                    }
                    if urls.count > 4 {
                        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                         url: urls[4],
                                         width: boxSize,
                                         height: boxSize)
                    }
                    if urls.count > 5 {
                        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                         url: urls[5],
                                         width: boxSize,
                                         height: boxSize)
                    }
                }
            }
            if urls.count > 6 {
                HStack(alignment: .top) {
                    if urls.count > 6 {
                        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                         url: urls[6],
                                         width: boxSize,
                                         height: boxSize)
                    }
                    if urls.count > 7 {
                        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                         url: urls[7],
                                         width: boxSize,
                                         height: boxSize)
                    }
                    if urls.count > 8 {
                        ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                         url: urls[8],
                                         width: boxSize,
                                         height: boxSize)
                    }
                }
            }
        }
    }
}

struct TimelineImagesView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineImagesView(urls: [URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/001.jpeg")!])
    }
}

//
//  TimelineContentItemView+ViewModel.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import Foundation

extension TimelineContentItemView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var profileImageURL: URL? = nil
        @Published private(set) var profileNick: String = ""
        @Published private(set) var showContent: Bool = false
        @Published private(set) var content: String = ""
        @Published private(set) var showImages: Bool = false
        @Published private(set) var images: [URL]? = nil
        
        init(tweet: Tweet) {
            profileImageURL = URL(string: tweet.createBy.avatarUrlPath)
            profileNick = tweet.createBy.nickname
            showContent = tweet.content != nil
            content = tweet.content ?? ""
            
            if let tweetImages = tweet.images, tweetImages.count > 0 {
                showImages = true
                images = tweetImages.map(\.url).map{ URL(string: $0)! }
            }
        }
    }
}

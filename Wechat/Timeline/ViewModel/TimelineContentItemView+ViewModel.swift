//
//  TimelineContentItemView+ViewModel.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import Foundation

extension TimelineContentItemView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var profileImageName: String = ""
        @Published private(set) var profileNick: String = ""
        @Published private(set) var content: String = ""
        @Published private(set) var showSinglePhotoName: Bool = false
        @Published private(set) var singlePhotoName: String = ""
        @Published private(set) var showLikes: Bool = false
        @Published private(set) var likes: [String] = []
        
        init(timelineContent: TimelineContent) {
            profileImageName = timelineContent.avatarUrl
            profileNick = timelineContent.nickname
            
            switch timelineContent.type {
            case .singleMessage(let message):
                content = message
                showSinglePhotoName = false
                break
            case .singlePhoto(let photo, let message):
                content = message ?? ""
                showSinglePhotoName = true
                singlePhotoName = photo
            }
            
            showLikes = timelineContent.likes.count > 0
            likes.append(contentsOf: timelineContent.likes)
        }
    }
}

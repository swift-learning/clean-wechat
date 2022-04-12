//
//  TimelineHeaderView+ViewModel.swift
//  Wechat
//
//  Created by Jian on 2022/3/1.
//

import Foundation
import Combine

extension TimelineHeaderView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var backgroundUrl: URL? = nil
        @Published private(set) var nickname: String = ""
        @Published private(set) var avatarUrl: URL? = nil
        
        private let timelineService: TimelineService
        private var subscription: Set<AnyCancellable> = .init()
        
        init(timelineService: TimelineService) {
            self.timelineService = timelineService
        }
        
        func loadData() {
            timelineService
                .retrieveCurrentUser()
                .sink { completion in
                    
                } receiveValue: { [unowned self] user in
                    self.nickname = user.nickname
                    if let profileUrlPath = user.profileUrlPath {
                        self.backgroundUrl = URL(string: profileUrlPath)
                    } else {
                        self.backgroundUrl = nil
                    }
                    self.avatarUrl = URL(string: user.avatarUrlPath)
                }
                .store(in: &subscription)

        }
    }
}

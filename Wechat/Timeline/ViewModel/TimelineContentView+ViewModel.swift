//
//  TimelineContentView+ViewModel.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import Foundation
import Combine

extension TimelineContentView {
    @MainActor final class ViewModel: ObservableObject {
        @Published private(set) var tweets: [Tweet] = []
        
        private let timelineService: TimelineService
        private var subscriptions: Set<AnyCancellable> = .init()
        
        init(timelineService: TimelineService) {
            self.timelineService = timelineService
        }
        
        func loadData() {
            timelineService
                .retrieveCurrentUserTweets()
                .handleEvents(receiveSubscription: { [weak self] subscription in
                    self?.tweets.removeAll()
                })
                .sink { completion in
                } receiveValue: { [weak self] tweets in
                    self?.tweets.append(contentsOf: tweets)
                }
                .store(in: &subscriptions)
        }
    }
}

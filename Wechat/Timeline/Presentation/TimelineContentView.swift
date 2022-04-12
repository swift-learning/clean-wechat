//
//  TimelineContentView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct TimelineContentView: View {
    @StateObject private var viewModel: ViewModel
    
    init(timelineService: TimelineService) {
        _viewModel = .init(wrappedValue: ViewModel(timelineService: timelineService))
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.tweets) { tweet in
                TimelineContentItemView(tweet: tweet)
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}

import Combine
struct TimelineContentView_Previews: PreviewProvider {
    private final class FakeTimelineService: TimelineService {
        func retrieveCurrentUser() -> AnyPublisher<User, TimelineServiceRetrieveCurrentUserError> {
            return Just(User(username: "jsmith",
                             nickname: "Huan Huan",
                             avatarUrlPath: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png",
                             profileUrlPath: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/profile-image.jpg"))
                .setFailureType(to: TimelineServiceRetrieveCurrentUserError.self)
                .eraseToAnyPublisher()
        }
        
        func retrieveCurrentUserTweets() -> AnyPublisher<[Tweet], TimelineServiceRetrieveCurrentUserTweetsError> {
            return Just([Tweet(id: 1,
                               content: "芒果鹿最近生病了, 不能一起玩.",
                               images: [],
                               createBy: User(username: "桃子猪",
                                              nickname: "桃子猪",
                                              avatarUrlPath: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar/001.jpeg",
                                              profileUrlPath: nil))])
                .setFailureType(to: TimelineServiceRetrieveCurrentUserTweetsError.self)
                .eraseToAnyPublisher()
        }
    }
    static var previews: some View {
        let loginedModel: LoginedModelFromHomeView = LoginedModelFromHomeView()
        let timelineService: TimelineService = FakeTimelineService()
        TimelineContentView(timelineService: timelineService)
            .environmentObject(loginedModel)
    }
}

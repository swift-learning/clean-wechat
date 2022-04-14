//
//  TimelineView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI


struct TimelineView: View {
    @Environment(\.currentUserProfile) var currentUserProfile: UserProfile
    @StateObject private var timelineDI = TimelineDI()
    
    var timelineService: TimelineService {
        return TimelineServiceImpl(wechatAPI: URLSessionWechatAPI(),
                                   currentLoginedUserProfile: currentUserProfile)
    }
    
    var retrieveCurrentUserTweetsUsecase: RetrieveCurrentUserTweetsUsecase {
        return RetrieveCurrentUserTweetsUsecase(tweetRepository: timelineDI.tweetRepository,
                                                    currentLoginedUserProfile: currentUserProfile)
    }
    
    var body: some View {
        List {
            TimelineHeaderView(timelineService: timelineService)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            TimelineContentView(retrieveCurrentUserTweetsUsecase: retrieveCurrentUserTweetsUsecase)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitle("朋友圈")
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let wechatAPI: WechatAPI = URLSessionWechatAPI()
        let profile: UserProfile = .init(username: "jsmith")
        let timelineService: TimelineService = TimelineServiceImpl(wechatAPI: wechatAPI, currentLoginedUserProfile: profile)
        
        TimelineView()
            .environment(\.timelineService, timelineService)
    }
}

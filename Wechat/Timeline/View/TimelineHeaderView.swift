//
//  TimelineHeaderView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct TimelineHeaderView: View {
    @StateObject private var viewModel: ViewModel
    
    init(timelineService: TimelineService) {
        _viewModel = StateObject(wrappedValue: ViewModel(timelineService: timelineService))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ImageLoadingView(placeholderImageName: "profile-image-placeholder",
                             url: viewModel.backgroundUrl,
                             width: nil,
                             height: 220)
            HStack {
                Text(viewModel.nickname)
                    .foregroundColor(.white)
                    .bold()

                ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                                 url: viewModel.avatarUrl,
                                 width: 70,
                                 height: 70)
            }
            .offset(x: -15, y: 25)
        }
        .padding(EdgeInsets(top: 0,
                            leading: 0,
                            bottom: 20,
                            trailing: 0))
        .onAppear {
            viewModel.loadData()
        }
    }
}

struct TimelineHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let wechatAPI: WechatAPI = URLSessionWechatAPI()
        let profile: UserProfile = .init(username: "jsmith")
        return TimelineHeaderView(timelineService: TimelineServiceImpl(wechatAPI: wechatAPI,
                                                                             currentLoginedUserProfile: profile))
    }
}

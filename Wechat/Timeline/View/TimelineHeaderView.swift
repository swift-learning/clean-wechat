//
//  TimelineHeaderView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct TimelineHeaderView: View {
    @EnvironmentObject private var loginedMode: LoginedModelFromHomeView

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(loginedMode.profile.backgroundUrl)
                .resizable()
                .scaledToFill()
            HStack {
                Text(loginedMode.profile.nickname)
                    .foregroundColor(.white)
                    .bold()
                Image(loginedMode.profile.avatarUrl)
                    .resizable()
                    .frame(width: 70,
                           height: 70)
            }
            .offset(x: -15, y: 15)
        }
        .padding(EdgeInsets(top: 0,
                            leading: 0,
                            bottom: 20,
                            trailing: 0))
    }
}

struct TimelineHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let loginedModel: LoginedModelFromHomeView = LoginedModelFromHomeView()
        return TimelineHeaderView()
            .environmentObject(loginedModel)
    }
}

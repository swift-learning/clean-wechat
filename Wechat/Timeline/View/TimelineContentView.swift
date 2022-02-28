//
//  TimelineContentView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct TimelineContentView: View {
    @EnvironmentObject private var loginedMode: LoginedModelFromHomeView
    @StateObject private var viewModel: ViewModel = .init()
    
    var body: some View {
        VStack {
            ForEach(viewModel.contents) {
                TimelineContentItemView(timelineContent: $0)
            }
        }
        .onAppear {
            viewModel.loadData(profile: loginedMode.profile)
        }
    }
}

struct TimelineContentView_Previews: PreviewProvider {
    static var previews: some View {
        let loginedModel: LoginedModelFromHomeView = LoginedModelFromHomeView()
        TimelineContentView()
            .environmentObject(loginedModel)
    }
}

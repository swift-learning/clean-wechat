//
//  TimelineContentItemView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct TimelineContentItemView: View {
    @StateObject private var viewModel: ViewModel
    
    init(timelineContent: TimelineContent) {
        _viewModel = StateObject(wrappedValue: ViewModel(timelineContent: timelineContent))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(viewModel.profileImageName)
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.profileNick)
                    .bold()
                Text(viewModel.content)
                    .fontWeight(.light)
                if viewModel.showSinglePhotoName {
                    Image(viewModel.singlePhotoName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                }
                if viewModel.showLikes {
                    TimelinkContentLikeView(likes: viewModel.likes)
                }
            }
            Spacer()
        }
    }
}

struct TimelineContentItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimelineContentItemView(timelineContent: TimelineContent(id: 1, nickname: "桃子猪", avatarUrl: "timeline_profile_image", type: .singleMessage(message: "不是我矫情,这年呐~,就是得和家人一起过才有味道."), likes: [""]))
            TimelineContentItemView(timelineContent: TimelineContent(id: 1, nickname: "芒果🦒", avatarUrl: "timeline_profile_image_lu", type: .singlePhoto(photo: "timeline_profile_image_lu_photo1", message: "草莓兔最近移情别恋, 都好久不和我在一起玩了. 哼~生气"), likes: []))
            TimelineContentItemView(timelineContent: TimelineContent(id: 1, nickname: "芒果🦒", avatarUrl: "timeline_profile_image_lu", type: .singlePhoto(photo: "timeline_profile_image_lu_photo1", message: "草莓兔最近移情别恋, 都好久不和我在一起玩了. 哼~生气"), likes: ["草莓🐰"]))
        }
    }
}

//
//  TimelineContentItemView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct TimelineContentItemView: View {
    @StateObject private var viewModel: ViewModel
    
    init(tweet: Tweet) {
        _viewModel = StateObject(wrappedValue: ViewModel(tweet: tweet))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ImageLoadingView(placeholderImageName: "avatar-image-placeholder",
                             url: viewModel.profileImageURL,
                             width: 50,
                             height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.profileNick)
                    .bold()
                if viewModel.showContent {
                    Text(viewModel.content)
                        .fontWeight(.light)
                }
                if let images = viewModel.images, viewModel.showImages {
                    TimelineImagesView(urls: images)
                }
            }
            Spacer(minLength: 0)
        }
    }
}

struct TimelineContentItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimelineContentItemView(tweet: Tweet(id: 1,
                                                 content: "不是我矫情,这年呐~,就是得和家人一起过才有味道.",
                                                 images: nil,
                                                 createBy: User(username: "zengheng",
                                                                nickname: "Huan huan",
                                                                avatarUrlPath: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png",
                                                                profileUrlPath: nil)))
            
            TimelineContentItemView(tweet: Tweet(id: 1,
                                                 content: "不是我矫情,这年呐~,就是得和家人一起过才有味道.",
                                                 images: [
                                                    TweetImage(url: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/001.jpeg")
                                                 ],
                                                 createBy: User(username: "zengheng",
                                                                nickname: "Huan huan",
                                                                avatarUrlPath: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png",
                                                                profileUrlPath: nil)))
            
            TimelineContentItemView(tweet: Tweet(id: 1,
                                                 content: "不是我矫情,这年呐~,就是得和家人一起过才有味道.",
                                                 images: [
                                                    TweetImage(url: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/001.jpeg"),
                                                    TweetImage(url: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/002.jpeg"),
                                                    TweetImage(url: "https://thoughtworks-mobile-2018.herokuapp.com/images/tweets/003.jpeg")
                                                 ],
                                                 createBy: User(username: "zengheng",
                                                                nickname: "Huan huan",
                                                                avatarUrlPath: "https://thoughtworks-mobile-2018.herokuapp.com/images/user/avatar.png",
                                                                profileUrlPath: nil)))
        }
    }
}

//
//  TweetDataSource.swift
//  Wechat
//
//  Created by weisite on 2022/4/14.
//

import Foundation
import Combine

enum TweetDataSourceRetriveTweetsError: Error {
    case internalError
    case empty
}

final class TweetDataSource {
    private let wechatAPI: WechatAPI

    init(wechatAPI: WechatAPI) {
        self.wechatAPI = wechatAPI
    }
    
    func retriveTweets(by username: String) -> AnyPublisher<[Tweet], TweetDataSourceRetriveTweetsError> {
        return wechatAPI.requestTweets(by: username)
            .handleError()
            .transformApiTweetToTweet()
            .eraseToAnyPublisher()
    }
}

private extension AnyPublisher where Output == [WechatAPITweet], Failure == WechatAPIRequestTweetsError {
    func handleError() -> AnyPublisher<[WechatAPITweet], TweetDataSourceRetriveTweetsError> {
        return mapError({ error in
            switch error {
            case .internalError, .userNotExist, .parametersError:
                return TweetDataSourceRetriveTweetsError.internalError
            }
        })
        .eraseToAnyPublisher()
    }
}

private extension AnyPublisher where Output == [WechatAPITweet], Failure == TweetDataSourceRetriveTweetsError {
    func transformApiTweetToTweet() -> AnyPublisher<[Tweet], TweetDataSourceRetriveTweetsError> {
        return compactMap { apiTweets in
            return apiTweets.compactMap { apiTweet in
                guard let sender = apiTweet.sender else {
                    return nil
                }
                
                let tweetImages: [TweetImage] = apiTweet.images?.map { apiTweetImage in
                    TweetImage(url: apiTweetImage.url)
                } ?? []
                
                return Tweet(id: apiTweet.id,
                             content: apiTweet.content,
                             images: tweetImages,
                             createBy: User(username: sender.username,
                                            nickname: sender.nick,
                                            avatarUrlPath: sender.avatar,
                                            profileUrlPath: nil))
            }
        }
        .eraseToAnyPublisher()
    }
}

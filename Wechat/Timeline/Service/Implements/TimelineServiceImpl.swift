//
//  URLSessionTimelineService.swift
//  Wechat
//
//  Created by Jian on 2022/2/28.
//

import Foundation
import Combine
import SwiftUI
import os

final class TimelineServiceImpl: TimelineService {
    private let wechatAPI: WechatAPI
    private let currentLoginedUserProfile: UserProfile
    private let jsonDecoder: JSONDecoder = .init()
    private let logger: Logger = Logger()
    
    init(wechatAPI: WechatAPI, currentLoginedUserProfile: UserProfile) {
        self.wechatAPI = wechatAPI
        self.currentLoginedUserProfile = currentLoginedUserProfile
    }
    
    func retrieveCurrentUser() -> AnyPublisher<User, TimelineServiceRetrieveCurrentUserError> {
        let username: String = currentLoginedUserProfile.username
        return wechatAPI.requestUserInfo(by: username)
            .handleError(logger: logger)
            .transformToUser()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func retrieveCurrentUserTweets() -> AnyPublisher<[Tweet], TimelineServiceRetrieveCurrentUserTweetsError> {
        let username: String = currentLoginedUserProfile.username
        return wechatAPI.requestTweets(by: username)
            .handleError(logger: logger)
            .removeInvalidationApiTweet()
            .transformApiTweetToTweet()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension EnvironmentValues {
    private struct TimelineServiceKey: EnvironmentKey {
        static let defaultValue: TimelineService = DefaultTimelineService()
    }
    
    var timelineService: TimelineService {
        get {
            self[TimelineServiceKey.self]
        }
        set {
            self[TimelineServiceKey.self] = newValue
        }
    }
    
    private final class DefaultTimelineService: TimelineService {
        func retrieveCurrentUser() -> AnyPublisher<User, TimelineServiceRetrieveCurrentUserError> {
            return Fail(error: TimelineServiceRetrieveCurrentUserError.internalError)
                .eraseToAnyPublisher()
        }
        
        func retrieveCurrentUserTweets() -> AnyPublisher<[Tweet], TimelineServiceRetrieveCurrentUserTweetsError> {
            return Fail(error: TimelineServiceRetrieveCurrentUserTweetsError.internalError)
                .eraseToAnyPublisher()
        }
    }
}

private extension AnyPublisher where Output == WechatAPIUserInfo, Failure == WechatAPIRequestUserInfoError {
    func handleError(logger: Logger) -> AnyPublisher<WechatAPIUserInfo, TimelineServiceRetrieveCurrentUserError>{
        return self.mapError({ error in
            switch error {
            case .internalError, .userNotExist:
                logger.debug("error: 系统错误")
                return TimelineServiceRetrieveCurrentUserError.internalError
            case .parametersError(let message):
                logger.debug("error: \(message)")
                return TimelineServiceRetrieveCurrentUserError.internalError
            }
        })
            .eraseToAnyPublisher()
    }
}

private extension AnyPublisher where Output == WechatAPIUserInfo, Failure == TimelineServiceRetrieveCurrentUserError {
    func transformToUser() -> AnyPublisher<User, TimelineServiceRetrieveCurrentUserError> {
        return map({ apiUserInfo in
            User(username: apiUserInfo.username,
                 nickname: apiUserInfo.nick,
                 avatarUrlPath: apiUserInfo.avatar,
                 profileUrlPath: apiUserInfo.profileImage)
        })
            .eraseToAnyPublisher()
    }
}


private extension AnyPublisher where Output == [WechatAPITweet], Failure == WechatAPIRequestTweetsError {
    func handleError(logger: Logger) -> AnyPublisher<[WechatAPITweet], TimelineServiceRetrieveCurrentUserTweetsError> {
        return mapError({ error in
            switch error {
            case .internalError, .userNotExist:
                logger.debug("error: 系统错误")
                return TimelineServiceRetrieveCurrentUserTweetsError.internalError
            case .parametersError(let message):
                logger.debug("error: \(message)")
                return TimelineServiceRetrieveCurrentUserTweetsError.internalError
            }
        })
        .eraseToAnyPublisher()
    }
}

private extension AnyPublisher where Output == [WechatAPITweet], Failure == TimelineServiceRetrieveCurrentUserTweetsError {
    func removeInvalidationApiTweet() -> AnyPublisher<[WechatAPITweet], TimelineServiceRetrieveCurrentUserTweetsError> {
        return compactMap { apiTweets in
            return apiTweets.filter { apiTweet in
                return apiTweet.sender != nil && (apiTweet.content != nil || apiTweet.images != nil)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func transformApiTweetToTweet() -> AnyPublisher<[Tweet], TimelineServiceRetrieveCurrentUserTweetsError> {
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

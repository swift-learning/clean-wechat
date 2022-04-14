//
//  RetrieveCurrentTweetsUseCase.swift
//  Wechat
//
//  Created by weisite on 2022/4/14.
//

import Foundation
import Combine

enum RetrieveCurrentUserTweetsUsecaseError: Error {
    case internalError
}

final class RetrieveCurrentUserTweetsUsecase {
    private let tweetRepository: TweetRepository
    private let currentLoginedUserProfile: UserProfile
    private var currentNumber: Int = 0
    private var tweets: [Tweet] = .init()

    init(tweetRepository: TweetRepository, currentLoginedUserProfile: UserProfile) {
        self.tweetRepository = tweetRepository
        self.currentLoginedUserProfile = currentLoginedUserProfile
    }
    
    func execute() -> AnyPublisher<[Tweet], RetrieveCurrentUserTweetsUsecaseError> {
        return tweetRepository
            .retrieveTweets(by: currentLoginedUserProfile.username)
            .handleError()
            .removeInvalidationTweets()
    }
}

private extension AnyPublisher where Output == [Tweet], Failure == TweetRepositoryRetrieveTweetsError {
    func handleError() -> AnyPublisher<[Tweet], RetrieveCurrentUserTweetsUsecaseError> {
        return mapError({ error in
            switch error {
            case .internalError:
                return RetrieveCurrentUserTweetsUsecaseError.internalError
            }
        })
        .eraseToAnyPublisher()
    }
}

private extension AnyPublisher where Output == [Tweet], Failure == RetrieveCurrentUserTweetsUsecaseError {
    func removeInvalidationTweets() -> AnyPublisher<[Tweet], RetrieveCurrentUserTweetsUsecaseError> {
        return compactMap { apiTweets in
            return apiTweets.filter { apiTweet in
                return apiTweet.content?.isEmpty == false || apiTweet.images?.isEmpty == false
            }
        }
        .mapError({ serviceError in
            RetrieveCurrentUserTweetsUsecaseError.internalError
        })
        .eraseToAnyPublisher()
    }
}


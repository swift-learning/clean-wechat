//
//  TweetRepository.swift
//  Wechat
//
//  Created by weisite on 2022/4/14.
//

import Foundation
import Combine
import os

enum TweetRepositoryRetrieveTweetsError: Error {
    case internalError
}

final class TweetRepository {
    private let remoteDataSource: TweetDataSource
    private let jsonDecoder: JSONDecoder = .init()
    private let logger: Logger = Logger()
    
    init(remoteDataSource: TweetDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func retrieveTweets(by username: String) -> AnyPublisher<[Tweet], TweetRepositoryRetrieveTweetsError> {
        return remoteDataSource
            .retriveTweets(by: username)
            .handleError()
            .eraseToAnyPublisher()
    }
}

private extension AnyPublisher where Output == [Tweet], Failure == TweetDataSourceRetriveTweetsError {
    func handleError() -> AnyPublisher<[Tweet], TweetRepositoryRetrieveTweetsError> {
        return mapError { error in
            switch error {
            case .internalError, .empty:
                return TweetRepositoryRetrieveTweetsError.internalError
            }
        }
        .eraseToAnyPublisher()
    }
}



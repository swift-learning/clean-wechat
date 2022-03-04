//
//  TimelineService.swift
//  Wechat
//
//  Created by Jian on 2022/2/28.
//

import Foundation
import Combine

protocol TimelineService {
    func retrieveCurrentUser() -> AnyPublisher<User, TimelineServiceRetrieveCurrentUserError>
    func retrieveCurrentUserTweets() -> AnyPublisher<[Tweet], TimelineServiceRetrieveCurrentUserTweetsError>
}

enum TimelineServiceRetrieveCurrentUserError: Error {
    case internalError
}

enum TimelineServiceRetrieveCurrentUserTweetsError: Error {
    case internalError
}

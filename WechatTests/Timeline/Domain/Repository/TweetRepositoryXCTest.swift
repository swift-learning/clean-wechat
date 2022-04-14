//
//  TweetRepositoryXCTest.swift
//  WechatTests
//
//  Created by weisite on 2022/4/14.
//

import XCTest
@testable import Wechat
import Combine

class TweetRepositoryXCTest: XCTestCase {
    
    final class FakeTweetDataSource: TweetDataSource {
        let tweets: [Tweet]
        
        init(tweets: [Tweet]) {
            self.tweets = tweets
        }
        
        func retriveTweets(by username: String) -> AnyPublisher<[Tweet], TweetDataSourceRetriveTweetsError> {
            return Just(tweets.filter { $0.createBy.username == username })
                .mapError { error in
                    return TweetDataSourceRetriveTweetsError.internalError
                }
                .eraseToAnyPublisher()
        }
    }

    func testTweetRepositoryShouldFindTweetByUserName() throws {
        let user1 = User(username: "first", nickname: "first", avatarUrlPath: "", profileUrlPath: nil)
        let user2 = User(username: "second", nickname: "second", avatarUrlPath: "", profileUrlPath: nil)
        let tweet1 = Tweet(id: 1, content: "from tweet 1", images: nil, createBy: user1)
        let tweet2 = Tweet(id: 2, content: "from tweet 2", images: nil, createBy: user2)
        let tweets = [tweet1, tweet2]
        var subscriptions: Set<AnyCancellable> = .init()
        var result: [Tweet] = []
        
        let tweetRepo = TweetRepository(remoteDataSource: FakeTweetDataSource(tweets: tweets))
        
        tweetRepo.retrieveTweets(by: user1.username)
            .sink { completion in
                
            } receiveValue: { tweets in
                result = tweets
            }
            .store(in: &subscriptions)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.content, tweet1.content)
    }

}

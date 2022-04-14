//
//  TweetRepositoryQuickTest.swift
//  WechatTests
//
//  Created by weisite on 2022/4/14.
//

import Quick
import Nimble
import Combine
@testable import Wechat

class TweetRepositoryQuickTest: QuickSpec {
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
    
    override func spec() {
        describe("find tweet") {
            context("when there are two tweets created by two different user and find one user's tweets") {
                it("returns one tweet") {
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
                    
                    expect(result).to(haveCount(1))
                }
            }
        }
    }
}


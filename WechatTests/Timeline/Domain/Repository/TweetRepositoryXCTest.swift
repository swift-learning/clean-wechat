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
    
    final class FakeWeChatAPI: WechatAPI {
        
        let wechatAPITweet: [WechatAPITweet]
        let wechatAPIUserInfo: WechatAPIUserInfo
        
        init(wechatAPITweet: [WechatAPITweet]) {
            self.wechatAPITweet = wechatAPITweet
            self.wechatAPIUserInfo = WechatAPIUserInfo(profileImage: "", avatar: "", nick: "", username: "")
        }
        
        func requestUserInfo(by username: String) -> AnyPublisher<WechatAPIUserInfo, WechatAPIRequestUserInfoError> {
            return Just(wechatAPIUserInfo)
                .mapError { error in
                    return WechatAPIRequestUserInfoError.internalError
                }
                .eraseToAnyPublisher()
        }
        
        func requestTweets(by username: String) -> AnyPublisher<[WechatAPITweet], WechatAPIRequestTweetsError> {
            return Just(wechatAPITweet.filter { $0.sender?.username == username })
                .mapError { error in
                    return WechatAPIRequestTweetsError.internalError
                }
                .eraseToAnyPublisher()
        }
    }

    func testTweetRepositoryShouldFindTweetByUserName() throws {
        let wechatAPITweet1 = WechatAPITweet(id: 1, content: "from tweet 1", images: nil, sender: WechatAPISender(username: "first", nick: "first", avatar: ""))
        let wechatAPITweet2 = WechatAPITweet(id: 2, content: "from tweet 2", images: nil, sender: WechatAPISender(username: "second", nick: "second", avatar: ""))
        let wechatAPITweets = [wechatAPITweet1, wechatAPITweet2]
        var subscriptions: Set<AnyCancellable> = .init()
        var result: [Tweet] = []
        
        let tweetRepo = TweetRepository(remoteDataSource: RemoteTweetDataSource(wechatAPI: FakeWeChatAPI(wechatAPITweet: wechatAPITweets)))
        
        tweetRepo.retrieveTweets(by: "first")
            .sink { completion in
                
            } receiveValue: { tweets in
                result = tweets
            }
            .store(in: &subscriptions)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.content, "from tweet 1")
    }

}

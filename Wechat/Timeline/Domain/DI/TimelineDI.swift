//
//  TimelineDI.swift
//  Wechat
//
//  Created by weisite on 2022/4/14.
//

import Foundation
import SwiftUI

class TimelineDI: ObservableObject {
    let wechatAPI: WechatAPI
    let tweetDataSource: TweetDataSource
    let tweetRepository: TweetRepository
    
    init() {
        self.wechatAPI = URLSessionWechatAPI()
        self.tweetDataSource = TweetDataSource(wechatAPI: self.wechatAPI)
        self.tweetRepository = TweetRepository(remoteDataSource: self.tweetDataSource)
    }
}

extension EnvironmentValues {
    struct TimelineDIKey: EnvironmentKey {
        static var defaultValue: TimelineDI = TimelineDI()
    }
    
    var timelineDI: TimelineDI {
        get {
            return self[TimelineDIKey.self]
        }
        set {
            self[TimelineDIKey.self] = newValue
        }
    }
}

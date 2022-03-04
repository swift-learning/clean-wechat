//
//  URLSessionWechatAPI.swift
//  Wechat
//
//  Created by Jian on 2022/2/28.
//

import Foundation
import Combine
import SwiftUI
import os

final class URLSessionWechatAPI: WechatAPI {
    private let jsonDecoder: JSONDecoder = .init()
    private let logger: Logger = .init()
    
    func requestUserInfo(by username: String) -> AnyPublisher<WechatAPIUserInfo, WechatAPIRequestUserInfoError> {
        if username.isEmpty {
            return Fail(error: WechatAPIRequestUserInfoError.parametersError(message: "用户名不可为空"))
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/user/\(username)") else {
            return Fail(error: WechatAPIRequestUserInfoError.parametersError(message: "用户名非法"))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WechatAPIUserInfo.self, decoder: jsonDecoder)
            .mapError({ _ in WechatAPIRequestUserInfoError.internalError })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestTweets(by username: String) -> AnyPublisher<[WechatAPITweet], WechatAPIRequestTweetsError> {
        if username.isEmpty {
            return Fail(error: WechatAPIRequestTweetsError.parametersError(message: "用户名不可为空"))
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: "https://thoughtworks-mobile-2018.herokuapp.com/user/\(username)/tweets") else {
            return Fail(error: WechatAPIRequestTweetsError.parametersError(message: "用户名非法"))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [WechatAPITweet].self, decoder: jsonDecoder)
            .mapError({ [weak self] error in
                self?.logger.error("requestTweets: \(error.localizedDescription)")
                return WechatAPIRequestTweetsError.internalError
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension EnvironmentValues {
    private struct WechatAPIKey: EnvironmentKey {
        static let defaultValue: WechatAPI = URLSessionWechatAPI()
    }
    
    var WechatAPI: WechatAPI {
        get {
            self[WechatAPIKey.self]
        }
        set {
            self[WechatAPIKey.self] = newValue
        }
    }
}

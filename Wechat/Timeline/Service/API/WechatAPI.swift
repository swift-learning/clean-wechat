//
//  WechatAPI.swift
//  Wechat
//
//  Created by Jian on 2022/2/28.
//

import Foundation
import Combine

protocol WechatAPI {
    func requestUserInfo(by username: String) -> AnyPublisher<WechatAPIUserInfo, WechatAPIRequestUserInfoError>
    func requestTweets(by username: String) -> AnyPublisher<[WechatAPITweet], WechatAPIRequestTweetsError>
}

enum WechatAPIRequestUserInfoError: Error {
    case internalError
    case userNotExist
    case parametersError(message: String)
}

enum WechatAPIRequestTweetsError: Error {
    case internalError
    case userNotExist
    case parametersError(message: String)
}

struct WechatAPIUserInfo: Decodable {
    let profileImage: String
    let avatar: String
    let nick: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile-image"
        case avatar = "avatar"
        case nick = "nick"
        case username = "username"
    }
}

struct WechatAPITweet: Decodable {
    let id: Int
    let content: String?
    let images: [WechatAPIImage]?
    let sender: WechatAPISender?
}

struct WechatAPIImage: Decodable {
    let url: String
}

struct WechatAPISender: Decodable {
    let username: String
    let nick: String
    let avatar: String
}

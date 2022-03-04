//
//  Tweet.swift
//  Wechat
//
//  Created by Jian on 2022/3/1.
//

import Foundation

struct Tweet: Identifiable {
    let id: Int
    let content: String?
    let images: [TweetImage]?
    let createBy: User
}

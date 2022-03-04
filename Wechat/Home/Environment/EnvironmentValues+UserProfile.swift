//
//  EnvironmentValues+UserProfile.swift
//  Wechat
//
//  Created by Jian on 2022/3/1.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    private struct UserProfileKey: EnvironmentKey {
        static var defaultValue: UserProfile = UserProfile(username: "")
    }
    
    var currentUserProfile: UserProfile {
        get {
            self[UserProfileKey.self]
        }
        set {
            self[UserProfileKey.self] = newValue
        }
    }
}

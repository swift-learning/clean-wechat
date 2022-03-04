//
//  HomeView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

enum HomeTab {
    case chat
    case addressList
    case exploration
    case me
}

struct HomeView: View {
    @StateObject private var loginedModel: LoginedModelFromHomeView = LoginedModelFromHomeView()
    @State private var selectionTab: HomeTab = .exploration
    
    private let currentUserProfile: UserProfile = UserProfile(username: "jsmith")
    
    var body: some View {
        TabView(selection: $selectionTab) {
            Text("微信页面")
                .tabItem {
                    Label("微信", systemImage: "message.fill")
                }
                .tag(HomeTab.chat)
            Text("通讯录页面")
                .tabItem {
                    Label("通讯录", systemImage: "phone.fill")
                }
                .tag(HomeTab.addressList)
            ExplorationView()
                .tag("发现")
                .tabItem {
                    Label("发现", systemImage: "safari.fill")
                }
                .tag(HomeTab.exploration)
                .environment(\.currentUserProfile, currentUserProfile)
            ProfileView()
                .tabItem {
                    Label("我", systemImage: "person.fill")
                }
                .tag(HomeTab.me)
        }
        .environmentObject(loginedModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

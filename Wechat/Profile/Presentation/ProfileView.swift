//
//  ProfileView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ProfileAvatarModificationView()) {
                    ProfileHeaderView()
                }
            }
            .listStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("我")
        }
        .navigationViewStyle(.stack)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let loginedModel = LoginedModelFromHomeView()
        return ProfileView()
            .environmentObject(loginedModel)
    }
}

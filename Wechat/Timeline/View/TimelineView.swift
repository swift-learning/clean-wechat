//
//  TimelineView.swift
//  Wechat
//
//  Created by Jian on 2022/2/8.
//

import SwiftUI


struct TimelineView: View {
    var body: some View {
        List {
            TimelineHeaderView()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            TimelineContentView()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationBarTitle("朋友圈")
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}

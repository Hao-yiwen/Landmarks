//
//  TabView.swift
//  Landmarks
//
//  Created by yw.hao on 2023/10/8.
//

import SwiftUI

struct TabViewContainer: View {
    @State private var selectedPage = 0

    var body: some View {
        TabView(selection: $selectedPage) {
            ForEach(0..<5) { index in
                Text("页面 \(index + 1)")
                    .font(.largeTitle)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewContainer()
    }
}

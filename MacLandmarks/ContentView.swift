//
//  ContentView.swift
//  MacLandmarks
//
//  Created by yw.hao on 2023/10/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LandmarkList()
            .frame(minWidth: 700, minHeight: 300)
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}

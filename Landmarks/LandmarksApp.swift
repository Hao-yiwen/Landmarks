//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by yw.hao on 2023/10/4.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @State private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
        .commands {
            LandmarkCommands()
        }
    }
}

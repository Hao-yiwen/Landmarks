//
//  CircleImage.swift
//  Landmarks
//
//  Created by yw.hao on 2023/10/5.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(
                Circle().stroke(.white, lineWidth: 4)
            )
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage()
}

//
//  ContentView.swift
//  Landmarks
//
//  Created by yw.hao on 2023/10/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .frame(height: 300)
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -138)
            
            VStack(alignment: .leading) {
                Text("Turtle")
                    .font(.title)
                    .foregroundColor(Color.black)
                HStack {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                    Text("ShangHai")
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
                Divider()
                
                Text("About Turtle Rock")
                    .font(.title2)
                Text("Descriptive text goes here.")
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

//
//  FloatingBottomBarView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI

struct FloatingBottomBarView<Content: View>: View {
    let content: Content

    // Initialize with buttons and content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            // Floating bottom bar
            VStack {
                Spacer()

                HStack {
                    Spacer() // Push buttons to the right
                    content
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    FloatingBottomBarView {
        Button {} label: {
            Image(systemName: "plus")
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}

//
//  FloatingBottomBarView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI

struct FloatingBottomBarView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                HStack {
                    Spacer() /// Spacer for pushing buttons to the right
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

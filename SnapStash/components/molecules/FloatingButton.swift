//
//  FloatingButton.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI

struct FloatingBottom: View {
    let icon: String
    let background: Color
    let size: CGFloat = 35
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .frame(width: size, height: size)
                .font(.title)
                .padding()
                .background(background)
                .foregroundColor(.white)
                .clipShape(Circle())
        }
    }
}


#Preview {
    FloatingBottom(icon: "plus", background: .blue) {}
}

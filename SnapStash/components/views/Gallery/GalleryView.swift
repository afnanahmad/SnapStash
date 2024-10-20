//
//  ContentView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [GalleryItem]

    var body: some View {
        ZStack {
            if items.isEmpty {
                Text("No Media Found")
                    .font(.title3)
            }
            
            FloatingBottomBarView {
                FloatingBottom(icon: "plus", background: .blue) {
                   // show media picker
                }
            }
        }
    }
}

#Preview {
    GalleryView()
        .modelContainer(for: GalleryItem.self, inMemory: true)
}

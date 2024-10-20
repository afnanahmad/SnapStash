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
    @Query(sort: \GalleryItem.timestamp, order: .reverse) private var items: [GalleryItem]

    @StateObject private var viewModel = GalleryViewModel()

    var body: some View {
        ZStack {
            if !viewModel.message.isEmpty {
                Text(viewModel.message)
                    .font(.title3)
            }
            
            FloatingBottomBarView {
                FloatingBottom(icon: "plus", background: .blue) {
                   // show media picker
                    viewModel.togglePicker()
                }
            }
        }
        .sheet(isPresented: $viewModel.showPicker) {
            PhotoLibraryView { assets in
                viewModel.importSelected(assets: assets)
            }
        }
    }
}

#Preview {
    GalleryView()
        .modelContainer(for: GalleryItem.self, inMemory: true)
}

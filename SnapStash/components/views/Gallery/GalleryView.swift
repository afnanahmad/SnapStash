//
//  ContentView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Photos
import SwiftData
import SwiftUI

struct GalleryView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var assetManager: AssetManager
    @Query(sort: \GalleryItem.timestamp, order: .reverse) private var items: [GalleryItem]

    @StateObject private var viewModel = GalleryViewModel()

    let columns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        ZStack {
            // Main content of the view
            if items.isEmpty {
                Text(viewModel.message)
                    .font(.title2)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items, id: \.fileName) { galleryItem in
                            GalleryItemThumbnailView(
                                galleryItem: galleryItem,
                                isSelected: viewModel.selectedItems.contains(galleryItem), // Pass selection state
                                onTap: {
                                    viewModel.toggleSelection(of: galleryItem) // Toggle selection on tap
                                },
                                onDoubleTap: {
                                    withAnimation { // Animate the full-screen action
                                        viewModel.showFullScreen(for: galleryItem)
                                    }
                                })
                        }
                        .transition(.scale)
                    }
                    .padding()
                }
            }

            FloatingBottomBarView {
                if !viewModel.selectedItems.isEmpty {
                    FloatingBottom(icon: "trash", background: .red) {
                        viewModel.deleteSeletcedItems(modelContext: modelContext,
                                                      assetManager: assetManager)
                    }
                }
                FloatingBottom(icon: "plus", background: .blue) {
                    viewModel.togglePicker()
                }
            }
        }
        .onAppear {
            viewModel.loadGalleryItems(from: modelContext)
        }
        .sheet(isPresented: $viewModel.showPicker) {
            PhotoLibraryView { assets in
                viewModel.importSelected(assets: assets,
                                         modelContext: modelContext,
                                         assetManager: assetManager) // Pass selected assets to ViewModel
            }
        }
        .fullScreenCover(item: $viewModel.fullScreenItem) { fullScreenItem in
            FullScreenMediaView(
                
            )
        }
    }
}

#Preview {
    GalleryView()
        .modelContainer(for: GalleryItem.self, inMemory: true)
}

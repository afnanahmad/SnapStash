//
//  GalleryThumbnailView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI

struct GalleryItemThumbnailView: View {
    let galleryItem: GalleryItem
    let isSelected: Bool
    let onTap: () -> Void
    let onDoubleTap: () -> Void

    @EnvironmentObject private var assetManager: AssetManager

    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                    .onAppear {
                        loadThumbnail()
                    }
            }

            // Highlight the selected item with a border
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(.blue, lineWidth: 3)
                    .frame(width: 100, height: 100)
            }
        }
        .simultaneousGesture(TapGesture(count: 2).onEnded {
            onDoubleTap()
        })
        .simultaneousGesture(TapGesture().onEnded {
            onTap()
        })
    }

    private func loadThumbnail() {
        /// Load the image from the gallery item's file URL
        // TODO: implement thumbnail caching in future
        if let fileURL = galleryItem.fileURL {
            if galleryItem.mediaType == .image {
                if let data = try? Data(contentsOf: fileURL), let uiImage = UIImage(data: data) {
                    image = uiImage
                }
            } else if galleryItem.mediaType == .video {
                /// Generate a thumbnail for the video
                image = assetManager.generateThumbnail(for: fileURL)
            }
        }
    }
}

//
//  AssetThumbnailView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Photos
import SwiftUI

/// Helper view to create thumbnail and handle asset selection
struct AssetThumbnailView: View {
    var asset: PHAsset
    var size: CGSize
    
    @State private var thumbnailImage: UIImage?
    
    var body: some View {
        ZStack {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(8)
                    
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: size.width, height: size.height)
                        .cornerRadius(8)
                        .onAppear {
                            fetchThumbnail()
                        }
                }
            }
        }
    }
    
    /// Fetch thumbnail for the asset
    private func fetchThumbnail() {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { image, _ in
            thumbnailImage = image
        }
    }
}

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
    var isSelected: Bool
    var selectionNumber: Int?
    
    @State private var thumbnailImage: UIImage?
    
    var body: some View {
        ZStack {
            if let image = thumbnailImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(8)
                    .overlay( /// Add a border around the image if selected
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(isSelected ? .blue : .clear, lineWidth: 3)
                    )
                    .overlay( /// Display the selection number if selected
                        Group {
                            if let number = selectionNumber {
                                Text("\(number + 1)") /// +1 to make it 1-based instead of 0-based
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Circle().fill(Color.blue))
                                    .padding(.top, 5)
                                    .padding(.leading, 8)
                            }
                        },
                        alignment: .topLeading
                    )
                    
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
            
            /// Show video indicator if the asset is a video
            if asset.mediaType == .video {
                Image(systemName: "video.fill")
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
                    .offset(x: size.width / 2 - 20, y: size.height / 2 - 20)
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

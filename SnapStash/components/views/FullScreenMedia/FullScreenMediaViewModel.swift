//
//  FullScreenMediaViewModel.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-20.
//

import AVKit
import SwiftUI

class FullScreenMediaViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var player: AVPlayer? = nil
    @Published var errorMessage: String? = nil

    let galleryItem: GalleryItem

    init(galleryItem: GalleryItem) {
        self.galleryItem = galleryItem
        loadMedia()
    }

    /// Load photo or video depending on the media type
    private func loadMedia() {
        guard let fileURL = galleryItem.fileURL else {
            errorMessage = "Invalid file URL."
            return
        }

        if galleryItem.mediaType == .image {
            loadImage(from: fileURL)
        } else if galleryItem.mediaType == .video {
            loadVideo(from: fileURL)
        }
    }

    /// Load the image from the file URL
    private func loadImage(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            image = UIImage(data: data)
        } catch {
            errorMessage = "Failed to load image from file."
        }
    }

    /// Initialize AVPlayer for video playback
    private func loadVideo(from url: URL) {
        player = AVPlayer(url: url)
        loopVideo()
    }

    /// Set up the AVPlayer to loop the video
    private func loopVideo() {
        guard let player = player else { return }
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}

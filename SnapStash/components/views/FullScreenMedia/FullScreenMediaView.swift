//
//  FullScreenMediaView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import AVKit
import SwiftUI

struct FullScreenMediaView: View {
    @StateObject private var viewModel: FullScreenMediaViewModel
    @Environment(\.presentationMode) var presentationMode

    init(galleryItem: GalleryItem) {
        _viewModel = StateObject(wrappedValue: FullScreenMediaViewModel(galleryItem: galleryItem))
    }

    var body: some View {
        ZStack {
            if let errorMessage = viewModel.errorMessage {
                /// Display error message if there is an issue
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(10)
                    .padding()
            } else {
                if viewModel.galleryItem.mediaType == .image {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
                    } else {
                        Text("Failed to load image")
                            .foregroundColor(.white)
                    }
                } else if viewModel.galleryItem.mediaType == .video {
                    if let player = viewModel.player {
                        VideoPlayer(player: player)
                            .onAppear {
                                player.play()
                            }
                            .onDisappear {
                                player.pause()
                            }
                            .ignoresSafeArea()
                    } else {
                        Text("Failed to load video")
                            .foregroundColor(.white)
                    }
                }
            }

            /// Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}


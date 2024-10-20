//
//  PhotoLibraryView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Photos
import PhotosUI
import SwiftUI

struct PhotoLibraryView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = PhotoLibraryViewModel()
    var onSelectedAssets: ([PHAsset]) -> Void

    var body: some View {
        NavigationStack {
            HStack {
                VStack {
                    Picker("MediaType", selection: $viewModel.selectedMediaType) {
                        ForEach(PhotoLibraryMediaType.allCases) { flavor in
                            Text(flavor.rawValue.uppercased())
                        }
                    }
                    .padding(.horizontal)
                    .pickerStyle(.segmented)

                    VStack {
                        switch viewModel.authorizationStatus {
                            case .notDetermined:
                                Text("Requesting access to the photo library...")
                                    .onAppear {
                                        viewModel.checkAuthorizationStatus() // Trigger access check
                                    }
                            case .authorized:
                                if viewModel.assets.isEmpty {
                                    Text("No items available")
                                } else {
                                    if viewModel.assets.isEmpty {
                                        VStack {
                                            Spacer()
                                            Text("Nothing Found")
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Spacer()
                                        }
                                    } else {
                                        ScrollView {
                                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                                                ForEach(viewModel.assets, id: \.self) { asset in
                                                    AssetThumbnailView(asset: asset,
                                                                       size: CGSize(width: 100, height: 100))
                                                }
                                            }
                                        }
                                        .padding()
                                    }
                                }
                            case .denied, .restricted:
                                Text("Access to the photo library is denied or restricted. Please enable access in Settings.")
                        }
                    }
                    .onChange(of: viewModel.selectedMediaType) {
                        viewModel.fetchAssets()
                    }
                }
            }
            .navigationBarTitle("Media Picker", displayMode: .inline)
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoLibraryView { _ in }
}

//
//  GalleryViewModel.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Photos
import SwiftData
import SwiftUI

class GalleryViewModel: ObservableObject {
    @Published var message = "No Media Found"
    @Published var showPicker = false

    @Published var selectedItems: Set<GalleryItem> = []
    @Published var fullScreenItem: GalleryItem?

    func loadGalleryItems(from modelContext: ModelContext) {}

    // Update the message based on the selected assets
    func updateMessage() {
        message = "No Media Found"
    }

    // Set the selected assets and persist them as GalleryItems
    func importSelected(assets: [PHAsset], modelContext: ModelContext, assetManager: AssetManager) {
        updateMessage()

        // Run the saving process asynchronously
        Task {
            await saveSelectedAssets(assets: assets, modelContext: modelContext, assetManager: assetManager)
        }
    }

    func toggleSelection(of item: GalleryItem) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }

    // Save assets asynchronously using AssetManager
    private func saveSelectedAssets(assets: [PHAsset], modelContext: ModelContext, assetManager: AssetManager) async {
        for asset in assets {
            do {
                // Use async/await to handle each asset saving process
                let fileName = try await assetManager.saveAsset(asset)
                let galleryItem = GalleryItem(timestamp: Date(), fileName: fileName, mediaType: asset.mediaType)
                modelContext.insert(galleryItem) // Save to SwiftData

                try modelContext.save()
            } catch {
                print("Failed to save asset: \(error)")
            }
        }
    }

    // Toggle the visibility of the photo picker
    func togglePicker() {
        showPicker.toggle()
    }

    func deleteSeletcedItems(modelContext: ModelContext, assetManager: AssetManager) {
        if !selectedItems.isEmpty {
            for selectedItem in selectedItems {
                let fileManager = FileManager.default
                if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let fileURL = documentsDirectory.appendingPathComponent(selectedItem.fileName)
                    _ = assetManager.deleteFile(at: fileURL)
                }

                do {
                    modelContext.delete(selectedItem)
                    try modelContext.save()
                } catch {
                    print("Failed to delete asset: \(error)")
                }
            }
            selectedItems.removeAll()
        }
    }

    // Show a gallery item in full screen
    func showFullScreen(for item: GalleryItem) {
        fullScreenItem = item
    }

    // Dismiss the full-screen view
    func dismissFullScreen() {
        fullScreenItem = nil
    }
}

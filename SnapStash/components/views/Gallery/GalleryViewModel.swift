//
//  GalleryViewModel.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI
import Photos

class GalleryViewModel: ObservableObject {
    @Published var message = "No Media Found"
    @Published var showPicker = false
    
    
    // MARK: - Actions
    // Toggle the visibility of the photo picker
    func togglePicker() {
        showPicker.toggle()
    }
    
    // MARK: - Import Items
    func importSelected(assets: [PHAsset]) {
        message = "Importing \(assets.count) items..."
    }
}
    

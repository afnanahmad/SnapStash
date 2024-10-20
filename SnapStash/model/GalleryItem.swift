//
//  Item.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Foundation
import Photos
import SwiftData

@Model
final class GalleryItem {
    var timestamp: Date
    var fileName: String
    var mediaTypeValue: Int // Add mediaType to distinguish between image and video

    init(timestamp: Date, fileName: String, mediaType: PHAssetMediaType) {
        self.timestamp = timestamp
        self.fileName = fileName
        self.mediaTypeValue = mediaType.rawValue
    }

    /// Computed property to get PHAssetMediaType from mediaTypeValue
    var mediaType: PHAssetMediaType? {
        return PHAssetMediaType(rawValue: mediaTypeValue)
    }
    
    /// Computed property to get file url
    var fileURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to find the documents directory.")
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
}

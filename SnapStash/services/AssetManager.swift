//
//  AssetManager.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import AVKit
import Photos
import SwiftUI

class AssetManager: ObservableObject {
    // MARK: - Public Methods

    /// Save the asset (image or video) to the file system and return the file name of the saved file
    func saveAsset(_ asset: PHAsset) async throws -> String {
        let fileManager = FileManager.default

        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw createError(domain: "FileManager", message: "Unable to access the documents directory.")
        }

        /// Determine file extension based on the media type
        let fileExtension = asset.mediaType == .image ? "jpg" : "mov"
        let fileName = "\(UUID().uuidString).\(fileExtension)"
        let destinationURL = documentsDirectory.appendingPathComponent(fileName)

        if asset.mediaType == .image {
            let imageData = try await requestImageData(for: asset)
            try imageData.write(to: destinationURL)
        } else if asset.mediaType == .video {
            let videoURL = try await requestVideoURL(for: asset)
            try fileManager.copyItem(at: videoURL, to: destinationURL)
        } else {
            throw createError(domain: "UnknownMediaType", message: "Unsupported media type.")
        }

        return fileName
    }

    /// Generate a thumbnail for a video file
    func generateThumbnail(for videoURL: URL) -> UIImage? {
        let asset = AVAsset(url: videoURL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true

        let thumbnailTime = CMTime(seconds: 0, preferredTimescale: 60) /// Thumbnail time at 0 seconds
        do {
            let cgImage = try assetImageGenerator.copyCGImage(at: thumbnailTime, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail for video: \(error)")
            return nil
        }
    }

    /// Delete a file at a given URL
    func deleteFile(at fileURL: URL) -> Bool {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
                print("File deleted successfully at \(fileURL)")
                return true
            } else {
                print("File not found at \(fileURL)")
                return false
            }
        } catch {
            print("Failed to delete file: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Private Methods

    /// Request image data asynchronously for a PHAsset
    private func requestImageData(for asset: PHAsset) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat

            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, info in
                self.handleRequestResponse(data: data, info: info, continuation: continuation)
            }
        }
    }

    /// Request the video URL asynchronously for a PHAsset
    private func requestVideoURL(for asset: PHAsset) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .automatic

            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
                if let urlAsset = avAsset as? AVURLAsset {
                    self.handleRequestResponse(data: urlAsset.url, info: info, continuation: continuation)
                } else {
                    continuation.resume(throwing: self.createError(domain: "PHImageManager", message: "Unable to retrieve video URL."))
                }
            }
        }
    }

    // MARK: - Helper Methods

    private func handleRequestResponse<T>(data: T?, info: [AnyHashable: Any]?, continuation: CheckedContinuation<T, Error>) {
        /// Return the requested data or report an error if data is nil
        if let data = data {
            continuation.resume(returning: data)
        } else {
            continuation.resume(throwing: createError(domain: "PHImageManager", message: "Unable to retrieve data."))
        }
    }

    private func createError(domain: String, message: String) -> NSError {
        return NSError(domain: domain, code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

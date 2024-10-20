//
//  PhotoLibraryViewModel.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Photos
import SwiftUI

class PhotoLibraryViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var assets: [PHAsset] = []
    @Published var authorizationStatus: PhotoLibraryAuthorizationStatus = .notDetermined
    @Published var selectedMediaType: PhotoLibraryMediaType = .all

    private var fetchResult: PHFetchResult<PHAsset>?

    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self) /// Unregister when done
    }

    // MARK: - Photo Library Authorization

    /// Check photo library authorization status
    func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()

        Task { @MainActor in
            switch status {
            case .notDetermined:
                requestPhotoLibraryAccess() /// If not determined, request access
            case .authorized:
                authorizationStatus = .authorized
                fetchAssets()
            case .denied, .limited:
                authorizationStatus = .denied
            case .restricted:
                authorizationStatus = .restricted
            @unknown default:
                authorizationStatus = .denied
            }
        }
    }

    /// Request permission to access the photo library
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { [weak self] _ in
            Task { @MainActor in
                self?.checkAuthorizationStatus() /// Re-check after the request is complete
            }
        }
    }

    // MARK: - Fetch Assets

    /// Fetch photos, videos or both
    func fetchAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        switch selectedMediaType {
        case .all:
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d OR mediaType == %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        case .photos:
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        case .videos:
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        }

        /// Fetch PHAsset objects
        fetchResult = PHAsset.fetchAssets(with: fetchOptions)

        /// Convert fetchResult to an array and publish it
        updateAssetsFromFetchResult()
    }

    /// Helper function to update the assets array from the fetch result
    private func updateAssetsFromFetchResult() {
        guard let fetchResult = fetchResult else { return }

        var assetsArray: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assetsArray.append(asset)
        }

        Task { @MainActor in
            self.assets = assetsArray
        }
    }

    // MARK: - Photo Library Change Observer

    /// PHPhotoLibraryChangeObserver method
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let fetchResult = fetchResult, let changes = changeInstance.changeDetails(for: fetchResult) else {
            return
        }

        /// Update the fetch result and refresh the assets array
        self.fetchResult = changes.fetchResultAfterChanges
        updateAssetsFromFetchResult()
    }
}

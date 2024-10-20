//
//  PhotoLibraryEnums.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

enum PhotoLibraryAuthorizationStatus {
    case notDetermined
    case authorized
    case denied
    case restricted
}

enum PhotoLibraryMediaType: String, CaseIterable, Identifiable, Equatable {
    case all, photos, videos
    var id: Self { self }
}

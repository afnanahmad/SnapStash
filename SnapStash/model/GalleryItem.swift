//
//  Item.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import Foundation
import SwiftData

@Model
final class GalleryItem {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

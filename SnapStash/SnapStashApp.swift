//
//  SnapStashApp.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI
import SwiftData

@main
struct SnapStashApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GalleryItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            GalleryView()
        }
        .modelContainer(sharedModelContainer)
    }
}

# SnapStash App

![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg) ![Xcode](https://img.shields.io/badge/Xcode-16.0%2B-blue.svg) ![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg)

## Overview
A SwiftUI & SwiftData-based gallery app that allows users to:
- Import images and videos from photos app.
- Select/deselect items to delete.
- Double-tap an item to view in full-screen.
- Uses MVVM architecture for clean code separation.

## Features

### 1. **GalleryView**
- Displays imported media in a grid using `LazyVGrid`.
- Single-tap for selection with visual feedback.
- Double-tap to open items in full-screen mode.
- Save/Delete/Fetch data from SwiftData

### 2. **PhotoLibrary View**
- Displays media from Photos app in a grid using `LazyVGrid` based on authorization type.
- Filter between media types (Photos, Video or Both)
- Select/Deselect items to import
- Show selection sequence

### 3. **FullScreenMediaView**
- Shows images or videos in full-screen.
- Auto-plays and loops videos.
- Displays error messages if media can't be loaded.
- Close button to return to the gallery.

## Architecture
- **MVVM Pattern**: Separates UI from business logic for maintainability.

## How to Run
1. Clone the repository.
2. Open in Xcode (Swift 5.5+ required).
3. Build and run on a simulator or device.

## Future Enhancements
- Cache media thumbnails
- Add ability to swipe between imported media while viewing an item in fullscreen.

## License
MIT License

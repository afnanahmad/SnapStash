//
//  PhotoLibraryView.swift
//  SnapStash
//
//  Created by Afnan Ahmad on 2024-10-19.
//

import SwiftUI

struct PhotoLibraryView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = PhotoLibraryViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Photo Library")
        }
        .navigationBarTitle("Media Picker", displayMode: .inline)
    }
}

#Preview {
    PhotoLibraryView()
}

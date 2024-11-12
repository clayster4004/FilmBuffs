//
//  CameraViewModel.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI
import UIKit

class CameraViewModel: ObservableObject {
    @Published var capturedImage: UIImage? = nil  // Stores the captured image
    @Published var isShowingCamera = false        // Controls whether the camera is open

    // Function to handle the captured image from the camera
    func handleCapturedImage(_ image: UIImage) {
        self.capturedImage = image
        self.isShowingCamera = false
    }
}



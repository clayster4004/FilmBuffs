//
//  ImagePicker.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI
import UIKit

// Protocol for UIKit
struct ImagePicker: UIViewControllerRepresentable {
    // This is needed to dismiss the camera view post picture taken
    @Environment(\.presentationMode) var presentationMode

    // Defines that it will be opening camera
    var sourceType: UIImagePickerController.SourceType = .camera
    // Allows that picture taken to be accessed
    var completionHandler: (UIImage) -> Void

    /// Configures UI image picker controller
    func makeUIViewController(context: Context) -> UIImagePickerController {
        // Initializes a new UIImagePickerController
        let picker = UIImagePickerController()
        // Sets the pickers source type to camera as opposed to photo lib and deligator to handle events
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }

    /// This function will be used to update the view if need be *unused*
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // TODO: Needed to conform to protocol
    }

    /// Coordinator needed to handle events like image selection and cancellation
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Coordinator class to handle UIImagePickerControllerDelegate methods
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        // Reference to ImagePicker instance
        let parent: ImagePicker

        init(_ picker: ImagePicker) {
            self.parent = picker
        }

        /// Handle the selected image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Extracts the selected image
            if let uiImage = info[.originalImage] as? UIImage {
                // Sends image back to SwiftUI
                parent.completionHandler(uiImage)
            }
            // Returns user to previous screen
            parent.presentationMode.wrappedValue.dismiss()
        }

        // Handle cancellation if user backs out
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

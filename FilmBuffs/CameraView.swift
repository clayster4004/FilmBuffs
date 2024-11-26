//
//  CameraView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

struct CameraView: View {
    // Observes the viewModel which contains the logic
    @ObservedObject var viewModel: CameraViewModel
    // Accept the navigator as an environment object; can be used here
    @EnvironmentObject var navi: MyNavigator

    var body: some View {
        VStack {
            // Singular open camera button on the page
            Button("Open Camera") {
                viewModel.isShowingCamera = true // Sets the "show camera" flag
            }
            .padding()
            
            // This view displays the captured picture *if available*
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            // Display the cropped face image *if available*
            if let croppedFace = viewModel.croppedFaceImage {
                Text("Detected Face:")
                    .padding(.top)
                Image(uiImage: croppedFace) // Shows the cropped face in a smaller window
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding()
            } else {
                if viewModel.capturedImage != nil {
                    Text("No face detected or still processing...")
                        .foregroundColor(.gray)
                        .padding(.top)
                }
            }

        }
        // This is needed to actually display the camera when the flag is set to true
        .sheet(isPresented: $viewModel.isShowingCamera) {
            // ImagePicker is used to displaying the camera
            ImagePicker(sourceType: .camera) { image in
                viewModel.handleCapturedImage(image)
            }
        }
        // When the picture is taken and available an alert will pop up running the facial detection.
        .alert(isPresented: $viewModel.showConfirmationAlert) {
            Alert(
                title: Text("Is this \(viewModel.identifiedPersonName ?? "the person")?"),
                primaryButton: .default(Text("Yes")) {
                    // If the person is correct the page will navigate and search for their information to display
                    viewModel.performManualSearch(navi: navi)
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}





//
//  CameraView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel: CameraViewModel
    @EnvironmentObject var navi: MyNavigator

    var body: some View {
        VStack {
            Button("Open Camera") {
                viewModel.isShowingCamera = true
            }
            .padding()
            
            if let image = viewModel.capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust as necessary
            }
            // Display the cropped face image (if available)
            if let croppedFace = viewModel.croppedFaceImage {
                Text("Detected Face:")
                    .padding(.top)
                Image(uiImage: croppedFace)
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
        .sheet(isPresented: $viewModel.isShowingCamera) {
            ImagePicker(sourceType: .camera) { image in
                viewModel.handleCapturedImage(image)
            }
        }
        .alert(isPresented: $viewModel.showConfirmationAlert) {
            Alert(
                title: Text("Is this \(viewModel.identifiedPersonName ?? "the person")?"),
                primaryButton: .default(Text("Yes")) {
                    viewModel.performManualSearch(navi: navi)  // Perform search if confirmed
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}





//
//  CameraView.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject var viewModel: CameraViewModel // Connecting us to the ViewModel
    
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
                    .frame(width: 200, height: 200) // For CoreML
            }
        }
        
        .sheet(isPresented: $viewModel.isShowingCamera) {
            ImagePicker(sourceType: .camera) { image in
                viewModel.handleCapturedImage(image)
            }
        }
    }
}


//#Preview {
//    CameraView(viewModel: CameraViewModel())
//}

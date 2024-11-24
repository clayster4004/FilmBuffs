//
//  CameraViewModel.swift
//  FilmBuffs
//
//  Created by Clay Beal on 11/5/24.
//

import SwiftUI
import Vision
import UIKit
import CoreML

class CameraViewModel: ObservableObject {
    @Published var isShowingCamera = false
    @Published var capturedImage: UIImage? = nil
    @Published var croppedFaceImage: UIImage? = nil  // To hold the cropped face
    @Published var identifiedPersonName: String? = nil // Used to hold identity
    @Published var showConfirmationAlert = false  // Controls whether to show the confirmation alert

    // Function to handle the captured image
    func handleCapturedImage(_ image: UIImage) {
        let fixedImage = image.fixedOrientation()  // Fix the orientation of the captured image
        self.capturedImage = fixedImage
        detectAndCropFace(from: fixedImage) { croppedImage in
            DispatchQueue.main.async {
                if let croppedImage = croppedImage {
                    self.croppedFaceImage = croppedImage.fixedOrientation()  // Fix orientation of the cropped image
                    self.performRecognition(on: croppedImage)
                } else {
                    self.croppedFaceImage = nil
                }
            }
        }
    }
    
    private func performRecognition(on image: UIImage) {
        guard let resizedImage = image.resized(to: CGSize(width: 256, height: 256)) else {
            print("Failed to resize image")
            return
        }
        
        guard let model = try? FacialDetectionv1_0(configuration: MLModelConfiguration()) else {
            print("Failed to load model")
            return
        }
        guard let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            print("Failed to convert UIImage to CVPixel Buffer")
            return
        }
        
        do {
            let prediction = try model.prediction(image: pixelBuffer)
            self.identifiedPersonName = prediction.target
            print("Identified Person: \(prediction.target)")
            self.showConfirmationAlert = true
        } catch {
            print("Error making prediction: \(error.localizedDescription)")
        }
    }
    
    // Function to manually initiate search based on identified person name
    func performManualSearch(navi: MyNavigator) {
        if let name = identifiedPersonName {
            let formattedName = name.replacingOccurrences(of: "_", with: " ")

            NetworkManager.shared.searchMoviesAndActors(query: formattedName) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        if let matchedActor = results.first(where: { $0.mediaType == "person" && $0.name == formattedName }) {
                            navi.navigate(to: .AboutActor(matchedActor.id))
                        } else {
                            print("Could not find actor details for \(formattedName)")
                        }
                    case .failure(let error):
                        print("Error searching for actor: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // Function to detect and crop face using Vision framework
    private func detectAndCropFace(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Face detection error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let results = request.results as? [VNFaceObservation], let faceObservation = results.first else {
                print("No faces detected.")
                completion(nil)
                return
            }
            
            // Crop the face from the image
            let boundingBox = faceObservation.boundingBox
            let croppedImage = self.cropImage(image, to: boundingBox)
            completion(croppedImage)
        }
        
        // Convert UIImage to CGImage
        guard let cgImage = image.cgImage else {
            print("Unable to convert UIImage to CGImage.")
            completion(nil)
            return
        }
        
        // Perform face detection request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([faceDetectionRequest])
        } catch {
            print("Failed to perform face detection: \(error.localizedDescription)")
            completion(nil)
        }
    }
    private func cropImage(_ image: UIImage, to boundingBox: CGRect) -> UIImage? {
        // Set enlargement factors for different sides
        let topEnlargementFactor: CGFloat = 0.25  // More focus on adding to the top of the head
        let overallEnlargementFactor: CGFloat = 0.2  // General enlargement for sides and bottom

        // Original bounding box properties
        let originalWidth = image.size.width * boundingBox.width
        let originalHeight = image.size.height * boundingBox.height
        let originalX = image.size.width * boundingBox.origin.x
        let originalY = image.size.height * (1 - boundingBox.origin.y) - originalHeight

        // Calculate the new enlarged width and height
        let newWidth = originalWidth * (1 + overallEnlargementFactor)
        let newHeight = originalHeight * (1 + overallEnlargementFactor + topEnlargementFactor)

        // Adjust X and Y coordinates to center the enlargement
        let newX = originalX - ((newWidth - originalWidth) / 2)
        let newY = originalY - (originalHeight * topEnlargementFactor / 2) - ((newHeight - originalHeight) / 2)

        // Ensure the cropping rectangle stays within the bounds of the original image
        let cropRect = CGRect(
            x: max(0, newX),
            y: max(0, newY),
            width: min(image.size.width - newX, newWidth),
            height: min(image.size.height - newY, newHeight)
        )

        // Crop the image
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
            print("Failed to crop image.")
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    // Resize the image to the target size
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let width = Int(size.width)
        let height = Int(size.height)
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32ARGB, attrs,
                                         &pixelBuffer)
        guard status == kCVReturnSuccess, let unwrappedBuffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(unwrappedBuffer, .readOnly)
        let data = CVPixelBufferGetBaseAddress(unwrappedBuffer)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedBuffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        guard let cgImage = self.cgImage else {
            return nil
        }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        CVPixelBufferUnlockBaseAddress(unwrappedBuffer, .readOnly)

        return unwrappedBuffer
    }
}


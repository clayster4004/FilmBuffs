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
    @Published var isShowingCamera = false             // Boolean for if the camera is showing
    @Published var capturedImage: UIImage? = nil       // Holds captured image
    @Published var croppedFaceImage: UIImage? = nil    // To hold the cropped face
    @Published var identifiedPersonName: String? = nil // Used to hold identity
    @Published var showConfirmationAlert = false       // Controls whether to show the confirmation alert

    // Function to handle the captured image
    func handleCapturedImage(_ image: UIImage) {
        let fixedImage = image.fixedOrientation()  // Ensures vertical image
        self.capturedImage = fixedImage
        // If there is a face in the image crop it to just see that face
        detectAndCropFace(from: fixedImage) { croppedImage in
            DispatchQueue.main.async {
                if let croppedImage = croppedImage {
                    self.croppedFaceImage = croppedImage.fixedOrientation()  // Ensures vertical image
                    self.performRecognition(on: croppedImage) // Try to identify the person
                } else {
                    self.croppedFaceImage = nil
                }
            }
        }
    }
    
    /// Core ML usage to try to idetifity the person in the image based on a trained model
    private func performRecognition(on image: UIImage) {
        // Resize the image to best match my training data
        guard let resizedImage = image.resized(to: CGSize(width: 256, height: 256)) else {
            print("Failed to resize image")
            return
        }
        
        // Define the model I am using
        guard let model = try? FacialDetectionv1_0(configuration: MLModelConfiguration()) else {
            print("Failed to load model")
            return
        }
        
        // This is required for Core ML model inputs
        guard let pixelBuffer = resizedImage.toCVPixelBuffer() else {
            print("Failed to convert UIImage to CVPixel Buffer")
            return
        }
        
        // This code may run an error
        do {
            // Insert the pixel buffer into the model to try and make a perdiction
            let prediction = try model.prediction(image: pixelBuffer)
            // Set the identified person as the output of the model
            self.identifiedPersonName = prediction.target
            self.showConfirmationAlert = true
        } catch {
            print("Error making prediction: \(error.localizedDescription)")
        }
    }
    
    /// Manually initiate search based on identified person name
    func performManualSearch(navi: MyNavigator) {
        // Take the persons name, like "Adam_Sandler" and take out the "_"
        if let name = identifiedPersonName {
            let formattedName = name.replacingOccurrences(of: "_", with: " ")
            
            // Search for their information via the API
            NetworkManager.shared.searchMoviesAndActors(query: formattedName) { result in
                DispatchQueue.main.async {
                    switch result {
                    // If they are found navigate to their view; Success!
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
        // Built in swift function to detect faces in photos
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Face detection error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            // Uses the first detected face
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
        
        // Convert UIImage to CGImage (so the framework can work with the image)
        guard let cgImage = image.cgImage else {
            print("Unable to convert UIImage to CGImage.")
            completion(nil)
            return
        }
        
        // Perform face detection request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            // Call the handler with the detected face for processing
            try handler.perform([faceDetectionRequest])
        } catch {
            print("Failed to perform face detection: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    /// Function used to crop the face to match the models data
    private func cropImage(_ image: UIImage, to boundingBox: CGRect) -> UIImage? {
        // Set enlargement factors for different sides
        let topEnlargementFactor: CGFloat = 0.25  // More focus on adding to the top of the head
        let overallEnlargementFactor: CGFloat = 0.2  // General enlargement for sides and bottom

        // Original bounding box properties
        let originalWidth = image.size.width * boundingBox.width
        let originalHeight = image.size.height * boundingBox.height
        let originalX = image.size.width * boundingBox.origin.x
        let originalY = image.size.height * (1 - boundingBox.origin.y) - originalHeight

        // Calculate the new enlarged width and height (so we can "blow up" the photo)
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
        // New image context with specific size
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        // Draw the image into the new context scaling it to fit
        self.draw(in: CGRect(origin: .zero, size: size))
        // Define the resized imaged and close
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    /// Adjust image orientation
    func fixedOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        // Reorients the image to be vertical
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
    
    /// Converts UIImage to CVPixelBuffer so it works with Core ML models
    func toCVPixelBuffer() -> CVPixelBuffer? {
        // Define width and height of the image in pixels
        let width = Int(size.width)
        let height = Int(size.height)
        
        // Specify compatibility attributes for the pixel buffer
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        // This will hold the image data
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height,
                                         kCVPixelFormatType_32ARGB, attrs,
                                         &pixelBuffer)
        // Ensure successful creation of the pixel buffer
        guard status == kCVReturnSuccess, let unwrappedBuffer = pixelBuffer else {
            return nil
        }

        // Lock it for writing
        CVPixelBufferLockBaseAddress(unwrappedBuffer, .readOnly)
        // Get a pointer to the pixel buffer's base address
        let data = CVPixelBufferGetBaseAddress(unwrappedBuffer)

        // Set up a Core Graphics context using the pixel buffer's memory
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(unwrappedBuffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        // Get the CGImage representation of the current UIImage
        guard let cgImage = self.cgImage else {
            return nil
        }
        // Draw the CGImage into the Core Graphics context
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        // Unlock the pixel buffer memory
        CVPixelBufferUnlockBaseAddress(unwrappedBuffer, .readOnly)

        return unwrappedBuffer
    }
}


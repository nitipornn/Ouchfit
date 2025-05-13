//
//  PackingAlbum.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 10/5/2568 BE.
//
//
//  PackingAlbum.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 10/5/2568 BE.
//

import SwiftUI

// PackingAlbum ใช้เก็บชื่ออัลบั้มและข้อมูลภาพที่แปลงเป็น Data
struct PackingAlbum: Identifiable, Equatable, Codable {
    let id = UUID()  // Unique identifier for each album
    var name: String  // Album name
    var imageData: [Data]  // Store image data (not UIImage directly)

    // Convert Data back to UIImage
    func images() -> [UIImage] {
        return imageData.compactMap { UIImage(data: $0) }
    }

    // Add an image to the album
    mutating func addImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            imageData.append(data)  // Add the image data to imageData array
        }
    }

    // Remove an image from the album
    mutating func removeImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            // Debug: Check if the image data exists in the array
            if let index = imageData.firstIndex(of: data) {
                print("Image found at index \(index), removing image.")
                imageData.remove(at: index)  // Remove the image data from imageData array
            } else {
                print("Image not found in imageData array.")
            }
        } else {
            print("Failed to convert UIImage to Data.")
        }
    }
}

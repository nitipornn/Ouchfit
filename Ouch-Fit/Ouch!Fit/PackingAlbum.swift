//
//  PackingAlbum.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 10/5/2568 BE.
//

import SwiftUI

// PackingAlbum ใช้เก็บชื่ออัลบั้มและข้อมูลภาพที่แปลงเป็น Data
struct PackingAlbum: Identifiable, Equatable, Codable {
    let id = UUID()  // ใช้ UUID เพื่อให้แต่ละอัลบั้มมีการระบุเอกลักษณ์
    var name: String  // ชื่ออัลบั้ม
    var imageData: [Data]  // เก็บข้อมูลภาพเป็น Data (ไม่ใช่ UIImage)

    // ฟังก์ชั่นแปลง Data กลับเป็น UIImage
    func images() -> [UIImage] {
        return imageData.compactMap { UIImage(data: $0) }
    }

    // ฟังก์ชั่นเพื่อเพิ่มภาพลงในอัลบั้ม
    mutating func addImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            imageData.append(data)  // แปลง UIImage เป็น Data และเก็บไว้ใน imageData
        }
    }
}

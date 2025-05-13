//
//  AlbumDetailView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 10/5/2568 BE.
//

import SwiftUI
import PhotosUI
//
//struct AlbumDetailView: View {
//    var album: PackingAlbum
//    @Binding var albums: [PackingAlbum]
//
//    @State private var selectedItems: [PhotosPickerItem] = []
//
//    var body: some View {
//        VStack {
//            ScrollView {
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
//                    ForEach(album.images, id: \.self) { image in
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 100)
//                            .clipped()
//                            .cornerRadius(8)
//                    }
//                }
//                .padding()
//            }
//
//            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
//                Text("Add Photo")
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                    .padding()
//            }
//            .onChange(of: selectedItems) { items in
//                for item in items {
//                    Task {
//                        if let data = try? await item.loadTransferable(type: Data.self),
//                           let image = UIImage(data: data) {
//                            if let index = albums.firstIndex(of: album) {
//                                albums[index].images.append(image)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .navigationTitle(album.name)
//    }
//}

//#Preview {
//    AlbumDetailView()
//}


struct AlbumDetailView: View {
    var album: PackingAlbum
    @Binding var albums: [PackingAlbum]
    @ObservedObject var wardrobeViewModel: WardrobeViewModel

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    // แสดงรูปภาพในอัลบั้ม
                    ForEach(album.images(), id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(8)
                    }
                }
                .padding()
            }

            // เลือกรูปจาก Wardrobe
            Text("Add Photo from Wardrobe")
                .font(.headline)
                .padding()

            // แสดงรูปภาพจาก Wardrobe
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(wardrobeViewModel.wardrobeItems) { item in
                        // ตรวจสอบว่า imageURL ไม่เป็นค่าว่างก่อน
                        if !item.imageURL.isEmpty {
                            // แปลง Base64 string เป็น UIImage
                            if let data = Data(base64Encoded: item.imageURL),
                               let image = UIImage(data: data) {
                                Button(action: {
                                    // เมื่อเลือกภาพจาก wardrobe
                                    selectedImage = image
                                    addImageToAlbum(image)  // แอดภาพไปอัลบั้ม
                                }) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .padding()

            // ปุ่มสำหรับเพิ่มภาพจาก PhotosPicker
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                Text("Select Photos from Gallery")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
            .onChange(of: selectedItems) { items in
                for item in items {
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            addImageToAlbum(image)
                        }
                    }
                }
            }
        }
        .navigationTitle(album.name)
    }

    // ฟังก์ชันในการเพิ่มภาพไปยังอัลบั้ม
    private func addImageToAlbum(_ image: UIImage) {
        if let albumIndex = albums.firstIndex(where: { $0.id == album.id }) {
            albums[albumIndex].addImage(image) // เพิ่มภาพไปยังอัลบั้ม
            saveAlbums()  // บันทึกข้อมูลอัลบั้ม
        }
    }

    // ฟังก์ชันในการบันทึกอัลบั้ม
    private func saveAlbums() {
        if let encoded = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(encoded, forKey: "albums")
        }
    }
}

#Preview {
    AlbumDetailView(album: PackingAlbum(name: "Test", imageData: []), albums: .constant([]), wardrobeViewModel: WardrobeViewModel())
}

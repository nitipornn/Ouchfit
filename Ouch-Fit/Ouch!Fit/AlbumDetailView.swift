//
//  AlbumDetailView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 10/5/2568 BE.
//

//import SwiftUI
//import PhotosUI
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

import SwiftUI
import PhotosUI

struct AlbumDetailView: View {
    var album: PackingAlbum
    @Binding var albums: [PackingAlbum]

    @State private var selectedItems: [PhotosPickerItem] = []

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
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

            PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
                Text("Add Photo")
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
                            if let albumIndex = albums.firstIndex(of: album) {
                                albums[albumIndex].addImage(image)  // เพิ่มภาพ
                                saveAlbums()  // บันทึกข้อมูลหลังเพิ่มภาพ
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(album.name)
    }

    // ฟังก์ชันในการบันทึกข้อมูลอัลบั้มลง UserDefaults
    private func saveAlbums() {
        if let encoded = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(encoded, forKey: "albums")
        }
    }
}

#Preview {
    AlbumDetailView(album: PackingAlbum(name: "Test", imageData: []), albums: .constant([]))
}

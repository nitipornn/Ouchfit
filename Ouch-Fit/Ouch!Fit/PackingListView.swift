//
//  PackingListView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 10/5/2568 BE.
//

//import SwiftUI
//
//struct PackingAlbum: Identifiable, Equatable {
//    let id = UUID()
//    var name: String
//    var images: [UIImage]
//}
//
//struct PackingListView: View {
//    @State private var albums: [PackingAlbum] = []
//    @State private var showCreateAlbum = false
//    @State private var newAlbumName = ""
//
//    var body: some View {
//        List {
//            ForEach(albums) { album in
//                NavigationLink(destination: AlbumDetailView(album: album, albums: $albums)) {
//                    Text(album.name)
//                }
//            }
//        }
//        .navigationTitle("Packing List Albums")
//        .toolbar {
//            Button(action: {
//                showCreateAlbum = true
//            }) {
//                Image(systemName: "plus")
//            }
//        }
//        .sheet(isPresented: $showCreateAlbum) {
//            VStack(spacing: 20) {
//                Text("New packing list").font(.headline)
//                TextField("Name your list...", text: $newAlbumName)
//                    .textFieldStyle(.roundedBorder)
//                    .padding(.horizontal)
//
//                Button("Create packing list") {
//                    guard !newAlbumName.isEmpty else { return }
//                    let newAlbum = PackingAlbum(name: newAlbumName, images: [])
//                    albums.append(newAlbum)
//                    newAlbumName = ""
//                    showCreateAlbum = false
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(8)
//
//                Spacer()
//            }
//            .padding()
//        }
//    }
//}
//
//
//#Preview {
//    PackingListView()
//}
import SwiftUI

struct PackingListView: View {
    @State private var albums: [PackingAlbum] = [] {
        didSet {
            saveAlbums()  // เมื่อข้อมูลอัลบั้มเปลี่ยนแปลงให้บันทึกข้อมูล
        }
    }
    @State private var showCreateAlbum = false
    @State private var newAlbumName = ""

    var body: some View {
        List {
            ForEach(albums) { album in
                NavigationLink(destination: AlbumDetailView(album: album, albums: $albums)) {
                    Text(album.name)
                }
            }
            .onDelete(perform: deleteAlbum)  // การลบแบบสไลด์
        }
        .navigationTitle("Packing List Albums")
        .toolbar {
            Button(action: {
                showCreateAlbum = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showCreateAlbum) {
            VStack(spacing: 20) {
                Text("New packing list").font(.headline)
                TextField("Name your list...", text: $newAlbumName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Create packing list") {
                    guard !newAlbumName.isEmpty else { return }
                    let newAlbum = PackingAlbum(name: newAlbumName, imageData: [])
                    albums.append(newAlbum)
                    newAlbumName = ""
                    showCreateAlbum = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            loadAlbums()  // โหลดข้อมูลเมื่อเริ่มต้น
        }
    }

    private func loadAlbums() {
        if let data = UserDefaults.standard.data(forKey: "albums") {
            if let decodedAlbums = try? JSONDecoder().decode([PackingAlbum].self, from: data) {
                albums = decodedAlbums
            }
        }
    }

    private func saveAlbums() {
        if let encoded = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(encoded, forKey: "albums")
        }
    }

    // ฟังก์ชันลบอัลบั้ม
    private func deleteAlbum(at offsets: IndexSet) {
        albums.remove(atOffsets: offsets)
        saveAlbums()  // บันทึกข้อมูลหลังลบอัลบั้ม
    }
}

#Preview {
    PackingListView()
}

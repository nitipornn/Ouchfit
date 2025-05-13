import SwiftUI
import PhotosUI

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
                    ForEach(Array(album.images().enumerated()), id: \.element) { (index, image) in
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                            
                            // ปุ่มลบ
                            Button(action: {
                                removeImageFromAlbum(at: index)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .padding(5)
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                                    .offset(x: 40, y: -40)
                            }
                        }
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

    // ฟังก์ชันในการลบภาพออกจากอัลบั้ม
    private func removeImageFromAlbum(at index: Int) {
        if let albumIndex = albums.firstIndex(where: { $0.id == album.id }) {
            // ลบภาพจาก imageData โดยใช้ index
            albums[albumIndex].imageData.remove(at: index)
            saveAlbums()  // บันทึกข้อมูลอัลบั้ม
        }
    }

    // ฟังก์ชันในการบันทึกอัลบั้ม
    private func saveAlbums() {
        // บันทึกข้อมูลอัลบั้มใหม่ใน UserDefaults
        if let encoded = try? JSONEncoder().encode(albums) {
            UserDefaults.standard.set(encoded, forKey: "albums")
        }
    }
}

#Preview {
    AlbumDetailView(album: PackingAlbum(name: "Test", imageData: []), albums: .constant([]), wardrobeViewModel: WardrobeViewModel())
}

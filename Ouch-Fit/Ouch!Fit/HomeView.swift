import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var selectedItem: PhotosPickerItem?
    @State private var accountName: String = ""
    @State private var isEditingName = false
    @State private var showImagePicker = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20) {
                    // รูปโปรไฟล์
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .onTapGesture {
                            showImagePicker = true
                        }

                    // ชื่อแอค
                    HStack {
                        if isEditingName {
                            TextField("Enter username", text: $accountName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(maxWidth: 200)
                        } else {
                            Text(accountName)
                                .font(.title2)
                                .bold()
                        }

                        Button(action: {
                            isEditingName.toggle()
                        }) {
                            Image(systemName: isEditingName ? "checkmark.circle.fill" : "pencil")
                                .foregroundColor(.gray)
                        }
                    }

                    // ปุ่มไอคอน
                    HStack(spacing: 40) {
                        NavigationLink(destination: PackingListView()) {
                            VStack {
                                Image(systemName: "bag.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                Text("Packing")
                                    .font(.caption)
                            }
                        }

                        HStack(spacing: 40) {
                            NavigationLink(destination: InsightView()) {
                                VStack {
                                    Image(systemName: "chart.bar.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text("Insight")
                                        .font(.caption)
                                }
                            }

                        }
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()

                // ปุ่มบวกมุมล่างขวา
                Button(action: {
                    print("Plus button tapped")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $selectedItem, matching: .images)
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileImage = Image(uiImage: uiImage)
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

// Preview

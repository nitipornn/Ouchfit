//
//  NewPostView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 9/5/2568 BE.
//


//import SwiftUI
//
//struct NewPostView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedImageName: String = "ootd1"
//    @State private var caption: String = ""
//
//    var onPost: (Post) -> Void
//
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                // เลือกรูป (ในที่นี้ใช้ชื่อจาก Assets)
//                Picker("เลือกรูป", selection: $selectedImageName) {
//                    ForEach(["ootd1", "ootd2", "ootd3", "ootd4"], id: \.self) { imageName in
//                        HStack {
//                            Image(imageName)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 50, height: 50)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                            Text(imageName)
//                        }.tag(imageName)
//                    }
//                }
//                .pickerStyle(.inline)
//
//                // ช่องใส่คำบรรยาย
//                TextField("เขียนคำบรรยาย...", text: $caption)
//                    .textFieldStyle(.roundedBorder)
//                    .padding()
//
//                Spacer()
//
//                Button("โพสต์") {
//                    let newPost = Post(
//                        username: "current_user", // ใส่ชื่อแอคของคุณ
//                        profileImageName: "Profile1", // หรือให้เลือกก็ได้
//                        postImageName: selectedImageName,
//                        caption: caption,
//                        likes: 0,
//                        comments: []
//                    )
//                    onPost(newPost)
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .padding()
//            }
//            .navigationTitle("สร้างโพสต์ใหม่")
//        }
//    }
//}

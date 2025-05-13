//
//  CommunityView.swift
//  Ouch!Fit
//
//  Created by Chanita Pornsaktawee on 29/4/2568 BE.
//

import SwiftUI
import PhotosUI // เพิ่ม import สำหรับ PhotosUI

// 1. โครงสร้างข้อมูล (Model)
struct Post: Identifiable {
    let id = UUID()
    let username: String
    let profileImageName: String
    let postImageName: String? // เปลี่ยนเป็น Optional String
    let caption: String
    var likes: Int
    var comments: [Comment]
    var isLiked: Bool = false
}

struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let text: String
}

// 2. Custom View สำหรับแสดงแต่ละโพสต์
struct PostView: View {
    @Binding var post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // ส่วนหัวของโพสต์
            HStack {
                Image(post.profileImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(post.username)
                    .font(.custom("Classyvogueregular", size: 20))
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)

            // รูปภาพโพสต์จาก Assets
            if let postImageName = post.postImageName { // Use if-let for optional binding
                Image(postImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.horizontal)
            } else {
                // Show a placeholder if there's no image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            // Like และ Comment
            HStack {
                Button(action: {
                    post.isLiked.toggle()
                    if post.isLiked {
                        post.likes += 1
                    } else {
                        post.likes -= 1
                    }
                }) {
                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(post.isLiked ? .red : .primary)
                }
                Text("\(post.likes) Likes")
                    .font(.custom("Classyvogueregular", size: 16))
                Spacer()
                Button(action: {
                    // TODO: ไปยังหน้าแสดงความคิดเห็น
                }) {
                    Image(systemName: "message")
                        .font(.title2)
                }
                Text("\(post.comments.count) Comments")
                    .font(.custom("Classyvogueregular", size: 12))
            }
            .padding(.horizontal)

            // คำบรรยาย
            Text(post.caption)
                .font(.custom("Classyvogueregular", size: 10))
                .foregroundColor(.gray)
                .padding(.horizontal)

            // แสดงคอมเมนต์ 2 อันแรก
            if !post.comments.isEmpty {
                VStack(alignment: .leading) {
                    ForEach(post.comments.prefix(2)) { comment in
                        Text("\(comment.username): \(comment.text)")
                            .font(.custom("Classyvogueregular", size: 10))
                            .padding(.horizontal)
                    }
                    if post.comments.count > 2 {
                        Button(action: {
                            // TODO: ไปยังหน้าแสดงความคิดเห็นทั้งหมด
                        }) {
                            Text("View all \(post.comments.count) comments")
                                .font(.custom("Classyvogueregular", size: 10))
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                    }
                }
            }

            Divider()
                .padding(.vertical, 5)
        }
        .padding(.bottom, 10)
    }
}

// 3. Community View
struct CommunityView: View {
    @State var posts: [Post] = [
        Post(
            username: "user1",
            profileImageName: "Profile1",
            postImageName: "ootd1",
            caption: "Beach day #ootd #fashion #casual",
            likes: 15,
            comments: [
                Comment(username: "friend1", text: "👊🏻"),
            ],
            isLiked: true
        ),
        Post(
            username: "fashionista",
            profileImageName: "Profile2",
            postImageName: "ootd2",
            caption: "Feeling chic in this outfit. ✨ #style #ootdfashion",
            likes: 25,
            comments: [
                Comment(username: "follower1", text: "ขอพิกัดหน่อยค่ะ")
            ],
            isLiked: false
        ),
        Post(
            username: "ootdlover",
            profileImageName: "Profile3",
            postImageName: "ootd3",
            caption: "Weekend vibes! ☀️ #outfitoftheday #weekendstyle",
            likes: 10,
            comments: [Comment(username: "wiggles", text: "น่ารักมากก ต้องลองแต่งตามบ้างแล้วค่ะ"),
                      Comment(username: "IloveMe", text: "ชอบสไตล์นี้ค่ะ")],
            isLiked: false
        ),
        Post(
            username: "instafashion",
            profileImageName: "Profile4",
            postImageName: "ootd4",
            caption: "New arrival! Loving this piece. ❤️ #fashiongram #newcollection",
            likes: 30,
            comments: [
                Comment(username: "buyer1", text: "น่าสนใจมากค่ะ"),
                Comment(username: "buyer2", text: "สวยค่ะ")
            ],
            isLiked: true
        )
    ]
    @State private var isShowingPostCreator = false // State สำหรับแสดงหน้าสร้างโพสต์

    var body: some View {
        NavigationView { // จำเป็นต้องมี NavigationView เพื่อใช้ .sheet
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
              

                        VStack(spacing: 20) {
                            ForEach($posts) { $post in
                                PostView(post: $post)
                            }
                        }
                        .padding(.horizontal)
                }

                // ปุ่มเพิ่มโพสต์ที่มุมล่างขวา
                Button(action: {
                    isShowingPostCreator = true // แสดงหน้าสร้างโพสต์เมื่อกด
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
            .navigationBarTitle("Ouch!Fitnity", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Ouch!Fitnity")
                        .font(.custom("Classyvogueregular", size: 24)) // Custom font
                        .bold()
                        .foregroundColor(.black) // Optional: set font color
                }}
            // ใช้ .sheet เพื่อแสดง PostCreatorView
            .sheet(isPresented: $isShowingPostCreator) {
                PostCreatorView(posts: $posts, isShowingPostCreator: $isShowingPostCreator)
            }
        }
    }
}

// 4. หน้าจอสร้างโพสต์ (PostCreatorView)
struct PostCreatorView: View {
    @Binding var posts: [Post] // รับ Binding เพื่ออัปเดต posts ใน CommunityView
    @Binding var isShowingPostCreator: Bool
    @State private var selectedImage: PhotosPickerItem?
    @State private var newPostImage: Image?
    @State private var caption: String = ""
    @State private var username: String = "new_user" // ดึงมาจากข้อมูลผู้ใช้
    @State private var profileImageName: String = "Profile1" // ดึงมาจากข้อมูลผู้ใช้
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Shere Your OOTD")
                        .font(.title)
                        .padding(.leading)
                    Spacer()
                    Button(action: {
                        isShowingPostCreator = false
                        dismiss()
                    }) {
                        Text("Cancel")
                            .font(.title2)
                            .padding(.trailing)
//                            .background(Color.clear)
                            .foregroundColor(.blue)

                    }
                }


                // แสดงภาพที่เลือก
                if let newPostImage = newPostImage {
                    newPostImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                        .onTapGesture { // ให้รูปภาพที่เลือกกดได้
                            selectedImage = nil // Clear selected image to remove preview
                            self.newPostImage = nil
                        }
                } else {
                    // ตัวเลือกรูปภาพ
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        preferredItemEncoding: .automatic
                    ) {
                        Image(systemName: "photo.badge.plus") // Use a system image
                            .font(.system(size: 150)) // Make the icon larger  <<-- Updated
                            .padding()
                        
//                            .background(Color.gray.opacity(0.2)) // Background for better visibility
//                            .clipShape(RoundedRectangle(cornerRadius: 8)) // Optional: Clip the shape
                    }
                    .onChange(of: selectedImage) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    newPostImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }
                }


                // ช่องใส่คำบรรยาย
                TextField("Enter your caption", text: $caption)
                    .padding()

                Spacer()

                // ปุ่มโพสต์ และ Cancel
                HStack {

                    Spacer() // Pushes the buttons to the edges
                    Button(action: {
                        if let newPostImage = newPostImage {
                            // กรณีมีรูปภาพ
                            let postName = "post_\(UUID().uuidString)" // สร้างชื่อที่ไม่ซ้ำ
                            saveImageToAssets(image: newPostImage, imageName: postName) // บันทึกลง Assets
                            let newPost = Post(
                                username: username,
                                profileImageName: profileImageName, // ใช้ข้อมูลผู้ใช้
                                postImageName: postName, // ใช้ชื่อที่บันทึก
                                caption: caption,
                                likes: 0,
                                comments: []
                            )
                            posts.insert(newPost, at: 0) // เพิ่มโพสต์ใหม่
                        } else {
                            let newPost = Post(
                                username: username,
                                profileImageName: profileImageName, // ใช้ข้อมูลผู้ใช้
                                postImageName: nil, // ใช้ชื่อที่บันทึก
                                caption: caption,
                                likes: 0,
                                comments: []
                            )
                            posts.insert(newPost, at: 0)
                        }
                        isShowingPostCreator = false // ปิดหน้าสร้างโพสต์
                        dismiss()

                    }) {
                        Image(systemName: "arrow.up.circle") // Use a system icon for Post
                            .font(.title2)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Circle()) // Make it a circle
                    }
                }
                .padding()
            }
            .padding()
//            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)

        }
    }
    // Function to save the image to asset
    func saveImageToAssets(image: Image, imageName: String) {
        guard let uiImage = image.asUIImage() else { return }

        //save to library
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)

        //code to save to asset

    }
}
extension Image {
    func asUIImage() -> UIImage? {
#if canImport(UIKit)
        return nil
#endif
        return nil
    }
}

// 5. Preview
struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}


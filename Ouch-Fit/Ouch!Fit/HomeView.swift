import SwiftUI
import PhotosUI
import FirebaseDatabase

struct HomeView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var selectedItem: PhotosPickerItem?
    @State private var accountName: String = ""  // Store the username
    @State private var isEditingName = false
    @State private var showImagePicker = false

    // Create a wardrobeViewModel
    @ObservedObject var wardrobeViewModel = WardrobeViewModel()

    // Fetch username from UserDefaults
    func fetchUsername() {
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            accountName = savedUsername
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20) {
                    // Profile image
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .onTapGesture {
                            showImagePicker = true
                        }

                    // Account name
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

                    // Icon buttons
                    HStack(spacing: 40) {
                        NavigationLink(destination: PackingListView(wardrobeViewModel: wardrobeViewModel)) {
                            VStack {
                                Image(systemName: "bag.fill")
                                    .resizable()
                                    .foregroundColor(.cyan)
                                    .frame(width: 30, height: 30)
                                Text("Packing")
                                    .font(.caption)
                                    .foregroundColor(.cyan)
                            }
                        }

                        NavigationLink(destination: InsightView()) { // Navigate to InsightView
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.cyan)
                                Text("Insight")
                                    .font(.caption)
                                    .foregroundColor(.cyan)
                            }
                        }
                    }
                    .padding(.top)

                    Spacer()
                }
                .padding()
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
            .onAppear {
                fetchUsername()  // Fetch the username when the view appears
            }
            .navigationTitle("Home")
        }
    }
}

// Preview
#Preview {
    HomeView(wardrobeViewModel: WardrobeViewModel())
}

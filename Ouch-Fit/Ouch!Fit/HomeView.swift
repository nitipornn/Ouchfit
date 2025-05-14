import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var selectedItem: PhotosPickerItem?
    @State private var accountName: String = ""  // Store the username
    @State private var isEditingName = false
    @State private var showImagePicker = false
    @State private var searchText = ""  // For searching wardrobe items

    @ObservedObject var wardrobeViewModel = WardrobeViewModel()

    // Fetch username from UserDefaults
    func fetchUsername() {
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            accountName = savedUsername
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Profile")
                    .font(.custom("Bristol", size: 30))
                    .fontWeight(.medium)
                VStack {
                    HStack {
                        profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.cyan)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            .onTapGesture {
                                showImagePicker = true
                            }
                            .padding(4)

                        // Account name
                        HStack {
                            if isEditingName {
                                TextField("Enter username", text: $accountName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 200)
                            } else {
                                Text(accountName)
                                    .font(.custom("Classyvogueregular", size: 20))
                                    .bold()
                            }

                            Button(action: {
                                isEditingName.toggle()
                            }) {
                                Image(systemName: isEditingName ? "checkmark.circle.fill" : "pencil")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()

                    // Search bar for filtering items
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.top)
                }

                // Scrollable content (Wardrobe items)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(wardrobeViewModel.wardrobeItems.filter {
                            searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
                        }) { item in
                            // Card for each item
                            itemCard(item: item)
                        }
                    }
                    .padding(.horizontal)
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
            .onAppear {
                fetchUsername()  // Fetch the username when the view appears
            }

        }
    }

    // Item Card View
    func itemCard(item: WardrobeItem) -> some View {
        VStack {
            ZStack(alignment: .bottom) {
                // Display image
                if let uiImage = UIImage(data: Data(base64Encoded: item.imageURL) ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .cornerRadius(10)
                } else {
                    Color.gray.opacity(0.1)
                        .frame(width: 250, height: 200)
                        .cornerRadius(10)
                }

                // Item name at the bottom of the card
                VStack {
                    Spacer() // Push the name to the bottom
                    Text(item.name)
                        .font(.custom("Classyvogueregular", size: 15))
                        .bold()
                        .foregroundColor(.black)
                }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            .frame(width: 250, height: 200)
        }
        .padding(.vertical, 10)
    }
}

// SearchBar View
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search items...", text: $text)
                .padding(8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .font(.custom("Classyvogueregular", size: 13))

            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 6)
            }
        }
        .padding(.horizontal)
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(wardrobeViewModel: WardrobeViewModel())  // Pass the wardrobeViewModel
    }
}

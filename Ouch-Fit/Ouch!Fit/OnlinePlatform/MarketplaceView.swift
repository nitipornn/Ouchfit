import SwiftUI
import PhotosUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

// MarketplaceItem Struct
struct MarketplaceItem: Identifiable {
    var id: String // Unique ID for each item
    var name: String
    var description: String
    var price: Double
    var contactSeller: String
    var imageURL: String?
    var postedByUserID: String? // ID of the user who posted
    var timestamp: Double?      // Server timestamp for sorting
}

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct MarketplaceView: View {
    @State private var items: [MarketplaceItem] = [] // Array to hold items
    @State private var showAddItemView = false  // Flag to show the AddItemView
    @State private var searchText = ""  // For searching marketplace items
    @State private var isLoading: Bool = true  // To indicate loading state
    @State private var fetchErrorMessage: String? = nil  // Error handling

    // Firebase reference to "all_market_items"
    private var dbRef: DatabaseReference {
        return Database.database().reference().child("User").child("all_market_items")
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Marketplace")
                    .font(.custom("Bristol", size: 30))
                    .fontWeight(.medium)
                    .foregroundColor(.black)

                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top)

                if isLoading {
                    ProgressView("Loading items...")
                        .padding()
                } else if let errorMessage = fetchErrorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                } else if items.isEmpty {
                    Text("No marketplace posts yet. Be the first to add one!")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(items.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }) { item in
                            itemRow(item: item)
                        }
                    }
                }

                // The button to trigger adding an item to Firebase automatically (no UI button)
                Button(action: {
                    addItemToDatabase()  // Trigger item addition automatically
                }) {
                    Text("Add New Item")
                        .font(.custom("Classyvogueregular", size: 13))
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .onAppear {
                fetchItemsFromFirebase()
            }
            .onDisappear {
                dbRef.removeAllObservers()
            }
        }
    }

    // Fetch items from Firebase Realtime Database
    func fetchItemsFromFirebase() {
        isLoading = true
        fetchErrorMessage = nil

        dbRef.observe(.value) { snapshot in
            isLoading = false
            guard snapshot.exists() else {
                self.items = []
                return
            }

            var fetchedItems: [MarketplaceItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let itemDict = snapshot.value as? [String: Any] {
                    let item = MarketplaceItem(
                        id: snapshot.key,
                        name: itemDict["name"] as? String ?? "N/A",
                        description: itemDict["description"] as? String ?? "No description",
                        price: itemDict["price"] as? Double ?? 0.0,
                        contactSeller: itemDict["contactSeller"] as? String ?? "N/A",
                        imageURL: itemDict["imageURL"] as? String,
                        postedByUserID: itemDict["postedByUserID"] as? String,
                        timestamp: itemDict["timestamp"] as? Double
                    )
                    fetchedItems.append(item)
                }
            }

            fetchedItems.sort { ($0.timestamp ?? 0) > ($1.timestamp ?? 0) }
            self.items = fetchedItems
        }
    }

    // Add item to Firebase Realtime Database
    func addItemToDatabase() {
        // Assuming the current user is authenticated
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User not logged in.")
            return
        }

        let newItemId = dbRef.childByAutoId().key ?? UUID().uuidString
        let newItemData: [String: Any] = [
            "contactSeller": "Alice, alice@example.com",
            "description": "Fallen Angles SizeS",
            "imageURL": "https://firebasestorage.googleapis.com/v0/b/ouch-fit.firebasestorage.app/o/marketplace_images%2FMESH%20TOP2.jpeg?alt=media&token=fa6d0a98-a7e4-4198-81c0-61a01113350b",
            "name": "MESH TOP",
            "postedByUserID": currentUserID,
            "price": 490,
            "timestamp": ServerValue.timestamp()
        ]

        dbRef.child(newItemId).setValue(newItemData) { error, _ in
            if let error = error {
                print("Error saving item: \(error.localizedDescription)")
            } else {
                print("Item added successfully!")
                fetchItemsFromFirebase()  // Refresh the list after adding the new item
            }
        }
    }

    // Row view for each marketplace item
    func itemRow(item: MarketplaceItem) -> some View {
        HStack(alignment: .top, spacing: 15) {
            if let imageURLString = item.imageURL, let url = URL(string: imageURLString) {
                AsyncImageView(url: url)
                    .frame(width: 90, height: 90)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white.opacity(0.7))
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.custom("Classyvogueregular", size: 18))
                    .bold()
                    .lineLimit(2)
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.custom("Classyvogueregular", size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(.cyan)
                Text(item.description)
                    .font(.custom("Classyvogueregular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 8)
    }

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

    // AsyncImageView for loading images from URL
    struct AsyncImageView: View {
        let url: URL

        var body: some View {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                case .failure(let error):
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Failed")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))

                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}


// AddItemView to post new items
struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var itemName = ""
    @State private var itemDescription = ""
    @State private var itemPrice: String = ""
    @State private var contactSeller = ""
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var uploadedImageURL: String? = nil
    @State private var selectedImageData: Data? = nil // To show a preview immediately

    @State private var isUploadingImage = false
    @State private var isSavingItem = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private var dbRef: DatabaseReference {
        return Database.database().reference().child("all_market_items")
    }
    private let storageRef = Storage.storage().reference().child("marketplace_images")

    private var canSave: Bool {
        !itemName.isEmpty &&
        !itemDescription.isEmpty &&
        Double(itemPrice) != nil && Double(itemPrice) ?? 0 > 0 &&
        !contactSeller.isEmpty &&
        uploadedImageURL != nil &&
        !isUploadingImage &&
        !isSavingItem &&
        Auth.auth().currentUser != nil
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $itemName)
                    TextEditor(text: $itemDescription)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                        )
                    TextField("Price", text: $itemPrice)
                        .keyboardType(.decimalPad)
                    TextField("Contact Seller", text: $contactSeller)
                }

                Section(header: Text("Product Image")) {
                    PhotosPicker(selection: $selectedImageItem, matching: .images, photoLibrary: .shared()) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Select Product Image")
                        }
                        .foregroundColor(.blue)
                    }
                    .onChange(of: selectedImageItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                let url = try await uploadImageToFirebaseStorage(imageData: data)
                                uploadedImageURL = url.absoluteString
                            }
                        }
                    }

                    if isUploadingImage {
                        HStack { ProgressView(); Text("Uploading...").foregroundColor(.gray) }
                    } else if let imageData = selectedImageData, let uiImage = UIImage(data: imageData) {
                         Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(8)
                    }
                }

                Section {
                    Button(action: saveItemAction) {
                        HStack {
                            Spacer()
                            Text("Save Item to Marketplace")
                            Spacer()
                        }
                    }
                    .disabled(!canSave)
                    .padding(.vertical, 8)
                    .background(canSave ? Color.green : Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("Add New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func saveItemAction() {
        // Check if the user is logged in
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            alertTitle = "Error"
            alertMessage = "User not logged in."
            showAlert = true
            return
        }
        
        // Validate the item price and other fields
        guard let price = Double(itemPrice), price > 0 else {
            alertTitle = "Invalid Price"
            alertMessage = "Please enter a valid price."
            showAlert = true
            return
        }
        
        guard !itemName.isEmpty, !itemDescription.isEmpty, !contactSeller.isEmpty else {
            alertTitle = "Missing Information"
            alertMessage = "Please fill in all required fields."
            showAlert = true
            return
        }
        
        // If no image URL, try uploading the image to Firebase Storage
        guard let finalImageURL = uploadedImageURL else {
            alertTitle = "Missing Image"
            alertMessage = "Please upload an image for the item."
            showAlert = true
            return
        }
        
        isSavingItem = true
        let newItemId = dbRef.childByAutoId().key ?? UUID().uuidString

        let newItemData: [String: Any] = [
            "name": itemName,
            "description": itemDescription,
            "price": price,
            "contactSeller": contactSeller,
            "imageURL": finalImageURL,
            "postedByUserID": currentUserID,
            "timestamp": ServerValue.timestamp()
        ]
        
        // Save the item to Firebase Realtime Database
        dbRef.child(newItemId).setValue(newItemData) { error, _ in
            isSavingItem = false
            if error == nil {
                // Reset fields if successful
                itemName = ""
                itemDescription = ""
                itemPrice = ""
                contactSeller = ""
                uploadedImageURL = nil
                dismiss()
            } else {
                // Handle any errors
                alertTitle = "Error"
                alertMessage = error?.localizedDescription ?? "Failed to save item."
                showAlert = true
            }
        }
    }


    func uploadImageToFirebaseStorage(imageData: Data) async throws -> URL {
        let imageFileName = UUID().uuidString + ".jpg"
        let imageRef = storageRef.child(imageFileName)

        // Upload image data to Firebase Storage
        return try await withCheckedThrowingContinuation { continuation in
            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                imageRef.downloadURL { url, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let url = url {
                        continuation.resume(returning: url)  // Return the download URL
                    }
                }
            }
        }
    }



}

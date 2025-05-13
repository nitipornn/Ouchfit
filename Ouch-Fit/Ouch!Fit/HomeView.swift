import SwiftUI
import PhotosUI
import FirebaseDatabase

struct HomeView: View {
    @State private var profileImage: Image = Image(systemName: "person.circle")
    @State private var selectedItem: PhotosPickerItem?
    @State private var accountName: String = ""
    @State private var isEditingName = false
    @State private var showImagePicker = false

    // Load the account name from UserDefaults when the view appears
    init() {
        // Retrieve the username from UserDefaults
        if let savedAccountName = UserDefaults.standard.string(forKey: "loggedInUsername") {
            _accountName = State(initialValue: savedAccountName)
        }
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20) {
                    // Profile Image
                    profileImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                        .onTapGesture {
                            showImagePicker = true
                        }

                    // Account Name
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
                            if isEditingName {
                                // Save the edited account name back to UserDefaults
                                UserDefaults.standard.set(accountName, forKey: "loggedInUsername")
                            }
                            isEditingName.toggle()
                        }) {
                            Image(systemName: isEditingName ? "checkmark.circle.fill" : "pencil")
                                .foregroundColor(.gray)
                        }
                    }

                    // Icon buttons
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

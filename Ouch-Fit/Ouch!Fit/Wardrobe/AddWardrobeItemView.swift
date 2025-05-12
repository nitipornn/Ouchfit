import SwiftUI
import UIKit

struct AddWardrobeItemView: View {
    @State private var name: String = ""
    @State private var color: String = "" // Default value for color
    @State private var category: String = ""
    @State private var brand: String = ""
    @State private var price: String = "" // Price as String to easily handle input
    @State private var size: String = ""
    @State private var datePurchased: Date = Date()
    @State private var season: String = ""
    @State private var location: String = "" // Location should be a single value (not an array)
    @State private var fabric: String = "" // Default value for fabric
    @State private var newLocation: String = "" // For adding new location
    
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    @ObservedObject var viewModel: WardrobeViewModel
    
    // Predefined options for colors and fabrics
    let availableColors = ["Red", "Blue", "Green", "Black", "White", "Yellow"]
    let availableFabrics = ["Cotton", "Wool", "Silk", "Polyester", "Leather", "Denim"]
    
    @Environment(\.presentationMode) var presentationMode // To dismiss after saving

    // Predefined locations
    let predefinedLocations = ["Home", "Condo", "Office"]

    var body: some View {
        NavigationView {
            Form {
                // Item details section
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Color Picker
                    Picker("Color", selection: $color) {
                        ForEach(availableColors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical)

                    // Fabric Picker
                    Picker("Fabric", selection: $fabric) {
                        ForEach(availableFabrics, id: \.self) { fabric in
                            Text(fabric).tag(fabric)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.vertical)

                    TextField("Brand", text: $brand)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Size", text: $size)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    // Price Field
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // Ensure price is a number (e.g., 99.99)

                    Picker("Category", selection: $category) {
                        Text("Shirt").tag("Shirt")
                        Text("Pants").tag("Pants")
                        // Add more categories as needed
                    }

                    Picker("Season", selection: $season) {
                        Text("Summer").tag("Summer")
                        Text("Winter").tag("Winter")
                        // Add more seasons if needed
                    }

                    DatePicker("Date Purchased", selection: $datePurchased, displayedComponents: .date)
                }

                // Location section (single selection)
                Section(header: Text("Location")) {
                    // Predefined Locations Picker (single selection)
                    Picker("Select Location", selection: $location) {
                        ForEach(predefinedLocations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    // TextField to add a new custom location
                    TextField("Add a custom location", text: $newLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top, 10)

                    // Button to add custom location to the list
                    Button(action: {
                        if !newLocation.isEmpty {
                            location = newLocation // Update selected location with the new custom location
                            newLocation = "" // Clear the text field after adding
                        }
                    }) {
                        Text("Add Location")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }

                // Image section
                Section(header: Text("Image")) {
                    VStack {
                        // Display the selected image if it exists
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }

                        Button("Pick Image") {
                            isImagePickerPresented.toggle()
                        }
                        .fullScreenCover(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
                        }
                    }
                }

                // Save Button
                Section {
                    Button("Save") {
                        // If the image is selected, convert it to a base64 string to store it
                        let imageData = selectedImage?.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
                        
                        // Convert the price string to a double
                        let priceValue = Double(price) ?? 0.0
                        
                        let newItem = WardrobeItem(
                            name: name, color: color, category: category,
                            brand: brand, price: priceValue, size: size,
                            datePurchased: datePurchased, season: season,
                            location: [location], fabric: fabric, imageURL: imageData
                        )
                        
                        viewModel.addItem(item: newItem)
                        
                        // Dismiss the current view after saving
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .navigationBarTitle("Add Wardrobe Item")
            .background(Color.white) // Set background to white
            .foregroundColor(.black) // Set text to black
        }
    }
}

struct AddWardrobeItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddWardrobeItemView(viewModel: WardrobeViewModel())
    }
}

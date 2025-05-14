import SwiftUI
import UIKit

struct AddWardrobeItemView: View {
    @State private var name: String = ""
    @State private var color: String = "White"
    @State private var category: String = "Shirt"
    @State private var brand: String = ""
    @State private var price: String = ""
    @State private var size: String = ""
    @State private var datePurchased: Date = Date()
    @State private var season: String = "All"
    @State private var location: String = ""
    @State private var fabric: String = "Cotton"
    @State private var newLocation: String = ""
    
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    @State private var finalImage: UIImage? = nil
    @State private var isImageConfirmed: Bool = false

    @ObservedObject var viewModel: WardrobeViewModel
    
    let availableColors = ["White", "Black", "Pink", "Green", "Red", "Brown", "Orange", "Blue", "Sky Blue", "Gray", "Yellow", "Purple"]
    let availableFabrics = ["Cotton", "Wool", "Silk", "Polyester", "Leather", "Denim"]
    
    @Environment(\.presentationMode) var presentationMode

    let predefinedLocations = ["Home", "Condo", "Office"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Color", selection: $color) {
                        ForEach(availableColors, id: \.self) { color in
                            Text(color).tag(color)
                        }
                    }

                    Picker("Fabric", selection: $fabric) {
                        ForEach(availableFabrics, id: \.self) { fabric in
                            Text(fabric).tag(fabric)
                        }
                    }

                    TextField("Brand", text: $brand)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Size", text: $size)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Category", selection: $category) {
                        Text("Shirt").tag("Shirt")
                        Text("Pants").tag("Pants")
                        Text("Short Skirt").tag("Short Skirt")
                        Text("Long Skirt").tag("Long Skirt")
                        Text("Baby Tee").tag("Baby Tee")
                        Text("T-Shirt").tag("T-Shirt")
                        Text("Shoes").tag("Shoes")
                        Text("Scarf").tag("Scarf")
                        Text("Hat").tag("Hat")
                    }

                    Picker("Season", selection: $season) {
                        Text("All").tag("All")
                        Text("Summer").tag("Summer")
                        Text("Winter").tag("Winter")
                        Text("Spring").tag("Spring")
                        Text("Rainy").tag("Rainy")
                    }

                    DatePicker("Date Purchased", selection: $datePurchased, displayedComponents: .date)
                }

                Section(header: Text("Location")) {
                    Picker("Select Location", selection: $location) {
                        ForEach(predefinedLocations, id: \.self) { location in
                            Text(location).tag(location)
                        }
                    }

                    TextField("Add a custom location", text: $newLocation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        if !newLocation.isEmpty {
                            location = newLocation
                            newLocation = ""
                        }
                    }) {
                        Text("Add Location")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }

                Section(header: Text("Image")) {
                    VStack {
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

                Section {
                    Button("Save") {
                        let imageData: String
                        
                        if let finalImage = finalImage {
                            imageData = finalImage.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
                        } else if let selectedImage = selectedImage {
                            imageData = selectedImage.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
                        } else {
                            imageData = ""
                        }

                        let priceValue = Double(price) ?? 0.0
                        
                        let newItem = WardrobeItem(
                            name: name,
                            color: color,
                            category: category,
                            brand: brand,
                            price: priceValue,
                            size: size,
                            datePurchased: datePurchased,
                            season: season,
                            location: [location],
                            fabric: fabric,
                            imageURL: imageData
                        )
                        
                        viewModel.addItem(item: newItem)
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
        }
    }
}


struct AddWardrobeItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddWardrobeItemView(viewModel: WardrobeViewModel())
    }
}

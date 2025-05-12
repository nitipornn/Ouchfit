import SwiftUI

struct AddWardrobeItemView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    @State private var itemName = ""
    @State private var color = ""
    @State private var category = ""
    @State private var brand = ""
    @State private var price: String = ""
    @State private var size = ""
    @State private var datePurchased = Date()
    @State private var season = ""
    @State private var locations: [String] = []
    @State private var fabric = ""
    @State private var imageURL = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $itemName)
                    TextField("Color", text: $color)
                    TextField("Category", text: $category)
                    TextField("Brand", text: $brand)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Size", text: $size)
                    DatePicker("Date Purchased", selection: $datePurchased, displayedComponents: .date)
                    TextField("Season", text: $season)
                    TextField("Fabric", text: $fabric)
                }
                
                Section(header: Text("Location")) {
                    TextField("Location", text: $locations, prompt: Text("Add multiple locations separated by commas"))
                }
                
                Button("Save Item") {
                    let newItem = WardrobeItem(
                        name: itemName,
                        color: color,
                        category: category,
                        brand: brand,
                        price: Double(price) ?? 0.0,
                        size: size,
                        datePurchased: datePurchased,
                        season: season,
                        location: locations.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                        fabric: fabric,
                        imageURL: imageURL
                    )
                    
                    viewModel.addItem(item: newItem)
                }
            }
            .navigationTitle("Add New Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // Dismiss the sheet
                    }
                }
            }
        }
    }
}

//
//  AddWardrobeItemView.swift
//  Ouch!Fit
//
//  Created by Chanita Pornsaktawee on 12/5/2568 BE.
//

import SwiftUI

struct AddWardrobeItemView: View {
    @State private var name: String = ""
    @State private var color: String = ""
    @State private var category: String = ""
    @State private var brand: String = ""
    @State private var price: Double = 0.0
    @State private var size: String = ""
    @State private var datePurchased: Date = Date()
    @State private var season: String = ""
    @State private var location: [String] = []
    @State private var fabric: String = ""
    
    @ObservedObject var viewModel: WardrobeViewModel

    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Name", text: $name)
                TextField("Color", text: $color)
                TextField("Brand", text: $brand)
                TextField("Size", text: $size)
                TextField("Fabric", text: $fabric)
                Picker("Category", selection: $category) {
                    Text("Shirt").tag("Shirt")
                    Text("Pants").tag("Pants")
                    // Add more categories
                }
                Picker("Season", selection: $season) {
                    Text("Summer").tag("Summer")
                    Text("Winter").tag("Winter")
                    // Add more seasons
                }
                DatePicker("Date Purchased", selection: $datePurchased, displayedComponents: .date)
            }

            Section(header: Text("Location")) {
                // Implement multi-select for locations
            }

            Section {
                Button("Save") {
                    let newItem = WardrobeItem(
                        name: name, color: color, category: category,
                        brand: brand, price: price, size: size,
                        datePurchased: datePurchased, season: season,
                        location: location, fabric: fabric, imageURL: ""
                    )
                    viewModel.addItem(item: newItem)
                }
            }
        }
    }
}

struct AddWardrobeItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddWardrobeItemView(viewModel: WardrobeViewModel())
    }
}

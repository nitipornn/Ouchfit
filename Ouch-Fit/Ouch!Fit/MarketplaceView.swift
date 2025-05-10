//
//  MarketplaceView.swift
//  Ouch!Fit
//
//  Created by Chanita Pornsaktawee on 29/4/2568 BE.
//
import SwiftUI
import PhotosUI

// 1. สร้าง struct สำหรับข้อมูลสินค้า
struct MarketplaceItem: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var price: Double
    var contactSeller: String // ข้อมูลติดต่อผู้ขาย
    var image: UIImage? // เปลี่ยนเป็น UIImage เพื่อเก็บรูปที่ผู้ใช้เลือก
}

struct MarketplaceView: View {
    @State private var items: [MarketplaceItem] = [
        MarketplaceItem(name: "T-shirt", description: "Comfortable cotton T-shirt", price: 19.99, contactSeller: "John Doe, 123-456-7890", image: UIImage(named: "MP1")),
        MarketplaceItem(name: "Jeans", description: "Stylish denim jeans", price: 39.99, contactSeller: "Jane Smith, 234-567-8901", image: UIImage(named: "MP2")),
        MarketplaceItem(name: "Sneakers", description: "Running sneakers with good support", price: 49.99, contactSeller: "Mark Lee/ 345-678-9012", image: UIImage(named: "MP3"))
    ]
    
    @State private var showAddItemView = false  // ใช้เพื่อแสดงหน้าจอเพิ่มสินค้า
    @State private var searchText = ""  // ฟังก์ชันค้นหาสินค้า

    var body: some View {
        NavigationView {
            VStack {
                // 2. เพิ่มฟังก์ชันการค้นหาสินค้า
                SearchBar(text: $searchText)
                    .padding()

                // 3. แสดงรายการสินค้าผ่าน List
                List {
                    ForEach(items.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            HStack {
                                // 4. การแสดงสินค้าทั้งหมดใน Card รูปแบบที่สะอาด
                                VStack(alignment: .leading) {
                                    Image(uiImage: item.image ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))

                                    Text(item.name)
                                        .font(.headline)
                                    Text("$\(item.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }

                                Spacer()
                            }
                            .padding()
                        }
                    }
                }
                .padding()

                // 5. ปุ่มเพิ่มสินค้า
                Button(action: {
                    showAddItemView = true
                }) {
                    Text("Add New Item")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Marketplace", displayMode: .inline)
            .sheet(isPresented: $showAddItemView) {
                AddItemView(items: $items)  // หน้าจอสำหรับเพิ่มสินค้า
            }
        }
    }
}

// 6. ฟังก์ชันการค้นหา
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search for items", text: $text)
                .padding(7)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 3)
        }
        .padding(.horizontal)
    }
}

// 7. หน้าจอสำหรับเพิ่มสินค้า
struct AddItemView: View {
    @Binding var items: [MarketplaceItem]
    @State private var itemName = ""
    @State private var itemDescription = ""
    @State private var itemPrice: String = ""
    @State private var contactSeller = ""
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Item")
                .font(.largeTitle)

            TextField("Item Name", text: $itemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Item Description", text: $itemDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Item Price", text: $itemPrice)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Contact Seller", text: $contactSeller)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // 8. เพิ่มปุ่มสำหรับเลือกภาพสินค้า
            PhotosPicker(selection: $selectedImageItem, matching: .images, photoLibrary: .shared()) {
                Text("Select Product Image")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }
            .onChange(of: selectedImageItem) { newItem in
                Task {
                    // ดึงข้อมูลรูปภาพ
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }

            Button(action: {
                if let price = Double(itemPrice), !itemName.isEmpty, !itemDescription.isEmpty, !contactSeller.isEmpty, selectedImageData != nil {
                    // เพิ่มสินค้าใหม่ในรายการ
                    let newItem = MarketplaceItem(name: itemName, description: itemDescription, price: price, contactSeller: contactSeller, image: UIImage(data: selectedImageData!)!)
                    items.append(newItem)  // เพิ่มสินค้าในรายการ
                    itemName = ""
                    itemDescription = ""
                    itemPrice = ""
                    contactSeller = ""
                    selectedImageData = nil
                }
            }) {
                Text("Save Item")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

// 9. หน้าจอสำหรับแสดงรายละเอียดสินค้า
struct ItemDetailView: View {
    var item: MarketplaceItem

    var body: some View {
        VStack {
            Image(uiImage: item.image ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()

            Text(item.name)
                .font(.largeTitle)
                .padding()

            Text(item.description)
                .padding()

            Text("$\(item.price, specifier: "%.2f")")
                .font(.title)
                .foregroundColor(.green)

            Text("Contact Seller: \(item.contactSeller)")
                .font(.footnote)
                .padding(.top, 10)

            Spacer()
        }
        .navigationBarTitle(item.name, displayMode: .inline)
        .padding()
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
    }
}

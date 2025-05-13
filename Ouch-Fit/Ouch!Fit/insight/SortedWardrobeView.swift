//
//  SortedWardrobeView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 13/5/2568 BE.
//

import SwiftUI

struct SortedWardrobeView: View {
    @ObservedObject var viewModel: WardrobeViewModel

    // Helper function to convert base64 string to UIImage
    func imageFromBase64(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String) {
            return UIImage(data: data)
        }
        return nil
    }

    var body: some View {
        List {
            // เรียงเสื้อผ้าจากราคาสูงสุดไปต่ำสุด
            ForEach(viewModel.wardrobeItems.sorted(by: { $0.price > $1.price })) { item in
                HStack {
                    VStack(alignment: .leading) {
                        // แสดงภาพสินค้า
                        if let uiImage = imageFromBase64(base64String: item.imageURL) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80) // กำหนดขนาดที่ต้องการ
                                .cornerRadius(10)
                        } else {
                            Color.gray.opacity(0.1)
                                .frame(width: 80, height: 80) // หากไม่มีภาพแสดง Placeholder
                                .cornerRadius(10)
                        }
                        
                        // แสดงข้อมูลสินค้า
                        Text(item.name)
                            .font(.headline)
                        
                        Text(item.brand)
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        Text("Color: \(item.color)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                       
                        Text("Size: \(item.size)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Fabric: \(item.fabric)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // แสดงราคา
                    Text("$\(item.price, specifier: "%.2f")")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("Price Sorting")
        .padding()
    }
}

struct SortedWardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        SortedWardrobeView(viewModel: WardrobeViewModel())
    }
}

//
//  SortedByDateView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 13/5/2568 BE.
//

import SwiftUI

struct SortedByDateView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    
    // Helper function to convert base64 string to UIImage
    func imageFromBase64(base64String: String) -> UIImage? {
        if let data = Data(base64Encoded: base64String) {
            return UIImage(data: data)
        }
        return nil
    }

    var body: some View {
        // List of wardrobe items sorted by their purchase date (most recent first)
        List {
            ForEach(viewModel.wardrobeItems.sorted(by: { $0.datePurchased > $1.datePurchased })) { item in
                HStack {
                    VStack(alignment: .leading) {
                        // Display item image
                        if let uiImage = imageFromBase64(base64String: item.imageURL) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80) // Fixed size for the image
                                .cornerRadius(10)
                        } else {
                            Color.gray.opacity(0.1)
                                .frame(width: 80, height: 80) // Fixed size for the image placeholder
                                .cornerRadius(10)
                        }
                        
                        // Display item name
                        Text(item.name)
                            .font(.headline)
                            .padding(.bottom, 5)

                        // Display item details
                        Text("Price: $\(item.price, specifier: "%.2f")")
                            .font(.headline)
                        Text("Size: \(item.size)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Brand: \(item.brand)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("Location: \(item.location.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        // Display the purchase date
                        Text("Purchased on: \(formattedDate(item.datePurchased))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Recently Acquired")
    }

    // Helper function to format the date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct SortedByDateView_Previews: PreviewProvider {
    static var previews: some View {
        SortedByDateView(viewModel: WardrobeViewModel())
    }
}

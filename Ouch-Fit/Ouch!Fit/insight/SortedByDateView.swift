//
//  SortedByDateView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 13/5/2568 BE.
//

import SwiftUI

struct SortedByDateView: View {
    @ObservedObject var viewModel: WardrobeViewModel

    var body: some View {
        // List of wardrobe items sorted by their purchase date (most recent first)
        List {
            ForEach(viewModel.wardrobeItems.sorted(by: { $0.datePurchased > $1.datePurchased })) { item in
                HStack {
                    VStack(alignment: .leading) {
                        // Display item name
                        Text(item.name)
                            .font(.headline)
                            .padding(.bottom, 5)

                        // Display item details
                        Text("Price: $\(item.price, specifier: "%.2f")")
                            .font(.headline)
                        Text("Color: \(item.color)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
        .navigationTitle("Recently acquired")
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

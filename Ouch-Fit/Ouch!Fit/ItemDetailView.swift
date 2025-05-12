//
//  Untitled.swift
//  Ouch!Fit
//
//  Created by Chanita Pornsaktawee on 12/5/2568 BE.
//

// ItemDetailView.swift
import SwiftUI

struct ItemDetailView: View {
    var item: MarketplaceItem
    
    var body: some View {
        VStack {
            if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 250, height: 250)
            }
            
            Text(item.name)
                .font(.largeTitle)
                .padding()
            
            Text(item.description)
                .font(.body)
                .padding()

            Text("Price: $\(item.price, specifier: "%.2f")")
                .font(.title)
                .padding()

            Text("Contact Seller: \(item.contactSeller)")
                .font(.footnote)
                .padding(.top, 10)
            
            Spacer()
        }
        .navigationBarTitle(item.name, displayMode: .inline)
    }
}

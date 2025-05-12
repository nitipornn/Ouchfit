//
//  SortedWardrobeView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 13/5/2568 BE.
//

import SwiftUI

struct SortedWardrobeView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    
    var body: some View {
        List {
            // เรียงเสื้อผ้าจากราคาสูงสุดไปต่ำสุด
            ForEach(viewModel.wardrobeItems.sorted(by: { $0.price > $1.price })) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        
                        Text((item.brand))
                            .font(.headline)
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

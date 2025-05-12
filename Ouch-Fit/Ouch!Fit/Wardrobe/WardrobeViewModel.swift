//
//  WardrobeViewModel.swift
//  Ouch!Fit
//
//  Created by Chanita Pornsaktawee on 12/5/2568 BE.
//


import Foundation
import SwiftUI

struct WardrobeItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var color: String
    var category: String
    var brand: String
    var price: Double
    var size: String
    var datePurchased: Date
    var season: String
    var location: [String]
    var fabric: String
    var imageURL: String // This will store the image as a base64 string or URL
}

import UIKit

class WardrobeViewModel: ObservableObject {
    @Published var wardrobeItems: [WardrobeItem] = []
    
    private let plistURL: URL
    // Initialize by loading items from the .plist
    init() {
        plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("WardrobeItems.plist")
        loadItems()
    }
    
    // Load items from the .plist file
    func loadItems() {
        if let data = try? Data(contentsOf: getDocumentsDirectory().appendingPathComponent("wardrobeItems.plist")),
           let decodedItems = try? PropertyListDecoder().decode([WardrobeItem].self, from: data) {
            wardrobeItems = decodedItems
        }
    }
    
    // Save items to the .plist file
    func saveItems() {
        if let encoded = try? PropertyListEncoder().encode(wardrobeItems) {
            try? encoded.write(to: getDocumentsDirectory().appendingPathComponent("wardrobeItems.plist"))
        }
    }
    
    // Add a new item to the wardrobe
    func addItem(item: WardrobeItem) {
        wardrobeItems.append(item)
        saveItems()
    }
    
    // Remove an item from the wardrobe
    func removeItem(item: WardrobeItem) {
        if let index = wardrobeItems.firstIndex(where: { $0.id == item.id }) {
            wardrobeItems.remove(at: index)
            saveItems()
        }
    }
    
    // Helper function to get the documents directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

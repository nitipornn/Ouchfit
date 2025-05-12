import SwiftUI
import Foundation

// Create a struct to define the Wardrobe Item
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
    var imageURL: String
}

// ViewModel to manage the wardrobe items
class WardrobeViewModel: ObservableObject {
    @Published var wardrobeItems: [WardrobeItem] = []

    init() {
        loadItems()
    }
    
    // Load items from UserDefaults or local storage
    func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "wardrobeItems") {
            if let decodedItems = try? JSONDecoder().decode([WardrobeItem].self, from: data) {
                wardrobeItems = decodedItems
            }
        }
    }
    
    // Save items to UserDefaults or local storage
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(wardrobeItems) {
            UserDefaults.standard.set(encoded, forKey: "wardrobeItems")
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
}

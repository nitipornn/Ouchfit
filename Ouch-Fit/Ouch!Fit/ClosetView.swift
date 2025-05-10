import SwiftUI

// Data model for Closet Item (with a name and a list of images for each category)
struct ClosetItem: Identifiable {
    var id = UUID()
    var name: String
    var images: [UIImage] = [] // Initially empty images list
}

struct ClosetView: View {
    // Example categories, starting with empty images for each
    @State private var categories = [
        ClosetItem(name: "Tops"),
        ClosetItem(name: "Shorts"),
        ClosetItem(name: "Dresses"),
        ClosetItem(name: "Bag")
    ]
    
    var body: some View {
        NavigationView {
            List(categories) { category in
                NavigationLink(destination: CategoryDetailView(category: category)) {
                    Text(category.name)
                        .font(.title2)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.vertical, 5)
            }
            .navigationBarTitle("Closet Categories", displayMode: .inline)
        }
    }
}

struct ClosetView_Previews: PreviewProvider {
    static var previews: some View {
        ClosetView()
    }
}

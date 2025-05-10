import SwiftUI
import UIKit

struct CategoryDetailView: View {
    @State var category: ClosetItem // Pass the selected category
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    
    // Grid layout for images (3 images per row)
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            Text(category.name)
                .font(.largeTitle)
                .padding()

            // Display images in a grid
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(category.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
            }
            .padding()

            Spacer()

            // Button to add a new image to the category
            Button(action: {
                showImagePicker.toggle() // Show image picker when tapped
            }) {
                Text("Add New Image")
                    .font(.title2)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage) // Show image picker
            }
        }
        .navigationBarTitle(category.name, displayMode: .inline)
        .onChange(of: selectedImage) { _ in
            // If a new image is selected, add it to the category
            if let selectedImage = selectedImage {
                category.images.append(selectedImage)
            }
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(category: ClosetItem(name: "Tops"))
    }
}

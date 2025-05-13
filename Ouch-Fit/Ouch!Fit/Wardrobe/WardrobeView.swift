import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel = WardrobeViewModel()
    @State private var editMode: Bool = false
    @State private var shakingItemId: UUID? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("Wardrobe Items")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(.black)

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        // Group items by category
                        let groupedItems = Dictionary(grouping: viewModel.wardrobeItems, by: { $0.category })
                        
                        ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                            VStack(alignment: .leading) {
                                // Category name
                                Text(category)
                                    .font(.title)
                                    .fontWeight(.medium)
                                    .padding(.leading)
                                    .foregroundColor(.black)

                                // Horizontal ScrollView for each category
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(groupedItems[category] ?? [], id: \.id) { item in
                                            VStack {
                                                ZStack(alignment: .topLeading) {
                                                    // Display the image
                                                    if let uiImage = UIImage(data: Data(base64Encoded: item.imageURL) ?? Data()) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 130, height: 130) // Fixed size for card
                                                            .cornerRadius(10)
                                                    } else {
                                                        Color.gray.opacity(0.1)
                                                            .frame(width: 130, height: 130) // Fixed size for card
                                                            .cornerRadius(10)
                                                    }
                                                    
                                                    // Delete button appears when editMode is active
                                                    if editMode {
                                                        Button(action: {
                                                            withAnimation {
                                                                viewModel.removeItem(item: item)
                                                            }
                                                        }) {
                                                            Image(systemName: "trash.fill")
                                                                .foregroundColor(.red)
                                                                .padding(5)
                                                        }
                                                        .offset(x: 10, y: 10)
                                                    }
                                                }
                                                
                                                // Item information
                                                Text(item.name)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                Text(item.brand)
                                                    .font(.subheadline)
                                                    .foregroundColor(.black)
                                                Text(item.size)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                    .padding(.top, 2)
                                            }
                                            .padding()
                                            .background(Color.white) // Minimalist white background for card
                                            .cornerRadius(10)
                                            .shadow(radius: 3)
                                            .modifier(ShakeEffect(animatableData: CGFloat(shakingItemId == item.id ? 1 : 0)))
                                            .onTapGesture {
                                                if editMode {
                                                    // Trigger shake animation when clicking the card while in edit mode
                                                    shakingItemId = item.id
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        shakingItemId = nil
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.leading)
                                }
                            }
                            .frame(height: 300) // Increased height for each category
                        }
                    }
                    .padding()
                }

                // Add Item Button
                NavigationLink(destination: AddWardrobeItemView(viewModel: viewModel)) {
                    Text("Add Item")
                        .font(.headline)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top)
                }

                // Edit Button to toggle edit mode
                Button(action: {
                    withAnimation {
                        editMode.toggle()
                    }
                }) {
                    Text(editMode ? "Done" : "Edit")
                        .font(.headline)
                        .padding()
                        .background(editMode ? Color.green : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top)
                }
            }
            .navigationBarTitle("Wardrobe", displayMode: .inline)
            .background(Color.white) // White background for minimal style
        }
    }
}

struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}

struct ShakeEffect: AnimatableModifier {
    var animatableData: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: animatableData * 10)
            .animation(.easeInOut(duration: 0.1).repeatCount(2, autoreverses: true), value: animatableData)
    }
}

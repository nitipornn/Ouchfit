import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel = WardrobeViewModel()
    @State private var editMode: Bool = false
    @State private var shakingItemId: UUID? = nil

    var body: some View {
        NavigationView {
            VStack {
                Text("Wardrobe")
                    .font(.custom("Bristol", size: 30))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        // Group items by category
                        let groupedItems = Dictionary(grouping: viewModel.wardrobeItems, by: { $0.category })
                        
                        ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                            VStack(alignment: .leading) {
                                // Category name with Edit button on the right side
                                HStack {
                                    Text(category)
                                        .font(.custom("Classyvogueregular", size: 17))
                                        .fontWeight(.medium)
                                        .foregroundColor(.black)

                                    Spacer()

                                    // Edit button to toggle edit mode for that category
                                    Button(action: {
                                        withAnimation {
                                            editMode.toggle()
                                        }
                                    }) {
                                        Image(systemName: editMode ? "checkmark.circle.fill" : "pencil.circle.fill")
                                            .foregroundColor(editMode ? .cyan : .black)
                                            .padding(5)
                                    }
                                }
                                .padding(.leading)
                                .padding(.top, 5)

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
                                                    .font(.custom("Classyvogueregular", size: 15))
                                                    .bold()
                                                    .foregroundColor(.cyan)
                                                Text(item.brand)
                                                    .font(.custom("Classyvogueregular", size: 13))
                                                    .foregroundColor(.black)
                                                Text(item.size)
                                                    .font(.custom("Classyvogueregular", size: 12))
                                                    .foregroundColor(.gray)
                                                    .padding(.top, 2)
                                            }
                                            .padding()
                                            .background(Color.white) // Minimalist white background for card
                                            .cornerRadius(10)
                                            .shadow(radius: 3)
                                            .modifier(ShakeEffect(animatableData: CGFloat(shakingItemId == item.id ? 1 : 0)))
                                            .onLongPressGesture(minimumDuration: 0.3) {
                                                // Trigger shake animation when holding the card in edit mode
                                                if editMode {
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
            }
            .overlay(
                // Add Item Button (Floating, Bottom-Right)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddWardrobeItemView(viewModel: viewModel)) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.cyan)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding(.trailing)
                        }
                    }
                    .padding(.bottom, 30)
                }
            )
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

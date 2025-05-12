import SwiftUI

struct WardrobeView: View {
    @ObservedObject var viewModel = WardrobeViewModel()
    @State private var editMode: Bool = false
    @State private var shakingItemId: UUID? = nil
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Wardrobe Items")
                    .font(.title)
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.wardrobeItems) { item in
                            VStack {
                                // Image, name, and brand displayed in the card
                                ZStack(alignment: .topLeading) {
                                    if let uiImage = UIImage(data: Data(base64Encoded: item.imageURL) ?? Data()) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .cornerRadius(10)
                                    } else {
                                        Color.gray.opacity(0.1)
                                            .frame(width: 150, height: 150)
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
                                Text(item.brand)
                                    .font(.subheadline)
                                Text(item.size)
                                    .font(.subheadline)
                                    .padding(.top, 2)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .frame(width: 150, height: 200)
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
                    .padding()
                }

                // Add Item Button
                NavigationLink(destination: AddWardrobeItemView(viewModel: viewModel)) {
                    Text("Add Item")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
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

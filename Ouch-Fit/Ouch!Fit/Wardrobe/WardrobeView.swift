//import SwiftUI
//
//struct WardrobeView: View {
//    @ObservedObject var viewModel = WardrobeViewModel()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Wardrobe")
//                    .font(.title)
//                    .padding()
//                
//                ScrollView(.horizontal) {
//                    LazyHStack {
//                        ForEach(viewModel.wardrobeItems) { item in
//                            VStack {
//                                // Card-like view to display each item
//                                Text(item.name)
//                                    .font(.headline)
//                                Text(item.color)
//                                    .font(.subheadline)
//                                Text(item.size)
//                                    .font(.subheadline)
//                            }
//                            .padding()
//                            .background(Color.gray.opacity(0.1))
//                            .cornerRadius(8)
//                            .frame(width: 150, height: 200)
//                        }
//                    }
//                    .padding()
//                }
//
//                Button(action: {
//                    // Navigate to Add Wardrobe Item View
//                }) {
//                    Text("Add Item")
//                        .font(.headline)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//        }
//    }
//}
//
//struct WardrobeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WardrobeView()
//    }
//}

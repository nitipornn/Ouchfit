//
//  InsightView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 12/5/2568 BE.
//
//import SwiftUI
//
//struct InsightView: View {
//    @State private var itemCount: Int = 0 // จำนวนสินค้า (ตัวอย่าง)
//    @State private var closetValue: Double = 0.0 // มูลค่าทั้งหมดของตู้เสื้อผ้า (ตัวอย่าง)
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//
//
//                // Item Count and Total Value
//                VStack(alignment: .leading) {
//                    Text("Item Count: \(itemCount)")
//                        .font(.title2)
//                        .padding(.bottom, 10)
//                    Text("Total Closet Value: $\(closetValue, specifier: "%.2f")")
//                        .font(.title2)
//                        .padding(.bottom, 20)
//                }
//
//                // Sections for each category
//                categorySection(title: "Color", destination: ColorDetailView(), icon: "paintpalette")
//                categorySection(title: "Season", destination: SeasonDetailView(), icon: "snowflake")
//                categorySection(title: "Size", destination: SizeDetailView(), icon: "rectangle.grid.1x2.fill")
//                categorySection(title: "Fabric", destination: FabricDetailView(), icon: "tshirt")
//                categorySection(title: "Brand", destination: BrandDetailView(), icon: "tag")
//                categorySection(title: "Location", destination: LocationDetailView(), icon: "location.circle.fill")
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Insight Stats")
//    }
//
//    // Updated category section
//    private func categorySection(title: String, destination: some View, icon: String) -> some View {
//        VStack(alignment: .leading) {
//            NavigationLink(destination: destination) {
//                InsightCategoryButton(label: title, icon: icon)
//            }
//        }
//        .padding(.bottom, 20)
//    }
//}
//
//// Custom Button for Category with updated color and icon
//struct InsightCategoryButton: View {
//    var label: String
//    var icon: String
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .resizable()
//                .frame(width: 30, height: 30)
//                .foregroundColor(.black) // Icon color set to black
//            Text(label)
//                .font(.title2)
//                .bold()
//                .foregroundColor(.black)
//            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color.gray.opacity(0.1)) // Background color set to light gray
//        .cornerRadius(10)
//        .padding(.vertical, 5)
//    }
//}
//
//// Example Detail Views (you can replace these with actual content)
//struct ColorDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Color Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Color")
//    }
//}
//
//struct SeasonDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Season Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Season")
//    }
//}
//
//struct SizeDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Size Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Size")
//    }
//}
//
//struct FabricDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Fabric Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Fabric")
//    }
//}
//
//struct BrandDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Brand Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Brand")
//    }
//}
//
//struct LocationDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Location Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Location")
//    }
//}
//
//struct InsightView_Previews: PreviewProvider {
//    static var previews: some View {
//        InsightView()
//    }
//}
import SwiftUI

struct InsightView: View {
    @ObservedObject var viewModel = WardrobeViewModel()

    // คำนวณสถิติจากข้อมูลใน viewModel
    private var itemCount: Int {
        viewModel.wardrobeItems.count
    }

    private var closetValue: Double {
        viewModel.wardrobeItems.reduce(0) { $0 + $1.price }
    }

    private var colorCount: [String: Int] {
        Dictionary(grouping: viewModel.wardrobeItems, by: { $0.color })
            .mapValues { $0.count }
    }

    private var seasonCount: [String: Int] {
        Dictionary(grouping: viewModel.wardrobeItems, by: { $0.season })
            .mapValues { $0.count }
    }

    private var sizeCount: [String: Int] {
        Dictionary(grouping: viewModel.wardrobeItems, by: { $0.size })
            .mapValues { $0.count }
    }

    private var fabricCount: [String: Int] {
        Dictionary(grouping: viewModel.wardrobeItems, by: { $0.fabric })
            .mapValues { $0.count }
    }

    private var brandCount: [String: Int] {
        Dictionary(grouping: viewModel.wardrobeItems, by: { $0.brand })
            .mapValues { $0.count }
    }

    private var locationCount: [String: Int] {
        Dictionary(grouping: viewModel.wardrobeItems, by: { $0.location.joined(separator: ", ") })
            .mapValues { $0.count }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // แสดงข้อมูลสถิติ
                VStack(alignment: .leading) {
                    Text("Item Count: \(itemCount)")
                        .font(.title2)
                        .padding(.bottom, 10)

                    Text("Total Closet Value: $\(closetValue, specifier: "%.2f")")
                        .font(.title2)
                        .padding(.bottom, 20)
                }

                // แสดงสถิติตามหมวดหมู่
                categorySection(title: "Color", countData: colorCount)
                categorySection(title: "Season", countData: seasonCount)
                categorySection(title: "Size", countData: sizeCount)
                categorySection(title: "Fabric", countData: fabricCount)
                categorySection(title: "Brand", countData: brandCount)
                categorySection(title: "Location", countData: locationCount)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Insight Stats")
    }

    // Method for creating category sections
    private func categorySection(title: String, countData: [String: Int]) -> some View {
        VStack(alignment: .leading) {
            Text("\(title) Breakdown")
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(countData.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                        .font(.body)
                    Spacer()
                    Text("\(countData[key]!)")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 2)
            }
        }
        .padding(.bottom, 20)
    }
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}

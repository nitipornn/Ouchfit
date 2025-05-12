////
////  InsightView.swift
////  Ouch!Fit
////
////  Created by Nitiporn Siriwimonwan on 12/5/2568 BE.
////
//
//import SwiftUI
//
//struct InsightView: View {
//    @State private var itemCount: Int = 0 // จำนวนสินค้า (ตัวอย่าง)
//    @State private var closetValue: Double = 0.0 // มูลค่าทั้งหมดของตู้เสื้อผ้า (ตัวอย่าง)
//    
//    // ตัวอย่างการแจกแจงข้อมูลต่างๆ
//    @State private var colorDistribution: [String: Int] = ["White": 5, "Black": 3, "Blue": 2]
//    @State private var seasonDistribution: [String: Int] = ["Spring": 4, "Summer": 3, "Fall": 2, "Winter": 1]
//    @State private var sizeDistribution: [String: Int] = ["S": 10, "M": 5, "L": 8]
//    @State private var fabricDistribution: [String: Int] = ["Cotton": 5, "Polyester": 3, "Silk": 2]
//    @State private var brandDistribution: [String: Int] = ["Nike": 3, "Adidas": 4, "Uniqlo": 2]
//    @State private var locationDistribution: [String: Int] = ["New York": 5, "Tokyo": 3, "London": 2]
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                Text("Style Stats")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding()
//
//                VStack(alignment: .leading) {
//                    Text("Item Count: \(itemCount)")
//                        .font(.title2)
//                        .padding(.bottom, 10)
//                    Text("Total Closet Value: $\(closetValue, specifier: "%.2f")")
//                        .font(.title2)
//                        .padding(.bottom, 20)
//                }
//
//                InsightCategorySection(title: "Color Breakdown", data: colorDistribution, navigateTo: ColorDetailView())
//                
//                InsightCategorySection(title: "Season Breakdown", data: seasonDistribution, navigateTo: SeasonDetailView())
//                
//                InsightCategorySection(title: "Size Breakdown", data: sizeDistribution, navigateTo: SizeDetailView())
//                
//                InsightCategorySection(title: "Fabric Breakdown", data: fabricDistribution, navigateTo: FabricDetailView())
//                
//                InsightCategorySection(title: "Brand Breakdown", data: brandDistribution, navigateTo: BrandDetailView())
//
//                InsightCategorySection(title: "Location Breakdown", data: locationDistribution, navigateTo: LocationDetailView())
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Insight Stats")
//    }
//    
//    // Generalized Category Section
//    private func InsightCategorySection(title: String, data: [String: Int], navigateTo: AnyView) -> some View {
//        VStack(alignment: .leading) {
//            Text(title)
//                .font(.title2)
//                .bold()
//                .padding(.bottom, 10)
//
//            ForEach(data.keys.sorted(), id: \.self) { category in
//                NavigationLink(destination: navigateTo) {
//                    HStack {
//                        Text("\(category)")
//                            .font(.headline)
//                        Spacer()
//                        Text("\(data[category] ?? 0) items")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    .padding()
//                }
//            }
//        }
//        .padding(.bottom, 20)
//    }
//}
//
//struct ColorDetailView: View {
//    var body: some View {
//        VStack {
//            Text("Color Details")
//                .font(.largeTitle)
//                .padding()
//            Spacer()
//        }
//        .navigationTitle("Color Breakdown")
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
//        .navigationTitle("Season Breakdown")
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
//        .navigationTitle("Size Breakdown")
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
//        .navigationTitle("Fabric Breakdown")
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
//        .navigationTitle("Brand Breakdown")
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
//        .navigationTitle("Location Breakdown")
//    }
//}
//
//struct InsightView_Previews: PreviewProvider {
//    static var previews: some View {
//        InsightView()
//    }
//}

//
//  InsightView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 12/5/2568 BE.

import SwiftUI

struct InsightView: View {
    @ObservedObject var viewModel = WardrobeViewModel()

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
                VStack(alignment: .leading) {
                    Text("Item Count: \(itemCount)")
                        .font(.title2)
                        .padding(.bottom, 10)

                    Text("Total Closet Value: $\(closetValue, specifier: "%.2f")")
                        .font(.title2)
                        .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom)

                // Display Color Breakdown with new colors
                colorBarChart

                // Display category statistics
                categorySection(title: "Color", countData: colorCount)
                categorySection(title: "Season", countData: seasonCount)
                categorySection(title: "Size", countData: sizeCount)
                categorySection(title: "Fabric", countData: fabricCount)
                categorySection(title: "Brand", countData: brandCount)
                categorySection(title: "Location", countData: locationCount)

                // Navigation Links
                NavigationLink(destination: SortedWardrobeView(viewModel: viewModel)) {
                    HStack {
                        Text("Price Sorting")
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top)
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: SortedByDateView(viewModel: viewModel)) {
                    HStack {
                        Text("Recently acquired")
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.top)
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Insight Stats")
    }

    // Category section method
    private func categorySection(title: String, countData: [String: Int]) -> some View {
        VStack(alignment: .leading) {
            Text("\(title)")
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

    // Color Bar Chart with new colors
    private var colorBarChart: some View {
        VStack(alignment: .leading) {
            Text("Color Breakdown")
                .font(.headline)
                .padding(.bottom, 5)

            HStack(spacing: 0) {
                let totalItems = CGFloat(itemCount)
                let barWidth = CGFloat(300)

                ForEach(["Red", "Blue", "Green", "Black", "White", "Yellow", "Pink", "Purple", "Sky Blue", "Orange", "Brown", "Tan", "Gray", "Beige", "KhaKi"], id: \.self) { color in
                    let count = colorCount[color] ?? 0
                    let colorWidth = calculateBarWidth(for: count, totalItems: totalItems, barWidth: barWidth)

                    Rectangle()
                        .fill(getColor(for: color))
                        .frame(width: colorWidth, height: 20)
                }
            }
            .frame(height: 20)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(5)
            .shadow(radius: 5)
        }
        .padding(.bottom, 10)
    }

    // Calculate bar width based on count
    private func calculateBarWidth(for count: Int, totalItems: CGFloat, barWidth: CGFloat) -> CGFloat {
        return CGFloat(count) / totalItems * barWidth
    }

    // Get color for each string name
    private func getColor(for color: String) -> Color {
        switch color {
        case "Red":
            return .red
        case "Blue":
            return .blue
        case "Green":
            return .green
        case "Black":
            return .black
        case "White":
            return .white
        case "Yellow":
            return .yellow
        case "Pink":
            return .pink
        case "Purple":
            return .purple
        case "Sky Blue":
            return Color.blue.opacity(0.6)
        case "Orange":
            return .orange
        case "Brown":
            return .brown
        case "Tan":
            return Color(white: 0.6)
        case "Gray":
            return .gray
        case "Beige":
            return Color(white: 0.9)
        case "KhaKi":
            return Color(white: 0.7)
        default:
            return .mint
        }
    }
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}

//
//  PlannerView.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 9/5/2568 BE.
//
import SwiftUI

struct PlannerView: View {
    @StateObject private var weatherManager = WeatherManager()  // สร้างออบเจ็กต์ WeatherManager
    @State private var currentDate = Date()  // เก็บวันที่ที่เลือกจากปฏิทิน

    var body: some View {
        VStack {
            // ปฏิทิน DatePicker สำหรับเลือกวันที่
            DatePicker("Select a Date", selection: $currentDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            // แสดงข้อมูลสภาพอากาศสำหรับวันที่เลือก
            Text("Weather on \(currentDate, formatter: dateFormatter):")
                .font(.title2)
                .padding()

            Text(weatherManager.weatherData)
                .font(.body)
                .padding()

            Spacer()
        }
        .onAppear {
            fetchWeather()  // ดึงข้อมูลสภาพอากาศเมื่อหน้าเพจโหลดขึ้น
        }
        .onChange(of: currentDate) { _ in
            fetchWeather()  // ดึงข้อมูลใหม่เมื่อเลือกวันที่ใหม่
        }
    }

    // ฟังก์ชันดึงข้อมูลสภาพอากาศจาก WeatherManager
    func fetchWeather() {
        let lat = 13.7563  // ละติจูดของกรุงเทพฯ
        let lon = 100.5018 // ลองจิจูดของกรุงเทพฯ
        weatherManager.fetchWeather(lat: lat, lon: lon)  // เรียกใช้ฟังก์ชัน fetchWeather
    }

    // DateFormatter สำหรับการแสดงวันที่ในปฏิทิน
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}

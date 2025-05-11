//
//  WeatherManager.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 9/5/2568 BE.
//

import Foundation

class WeatherManager: ObservableObject {
    @Published var weatherData: String = "Loading..."  // ใช้ในการเก็บข้อมูลสภาพอากาศ

    // ฟังก์ชันดึงข้อมูลสภาพอากาศจาก API
    func fetchWeather(lat: Double, lon: Double) {
        let apiKey = "2f869acb1b0882304a88cc91e8ae9de0"  // ใส่ API Key ของคุณที่นี่
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            self.weatherData = "Invalid URL"
            return
        }
        
        // ส่งคำขอไปยัง API และดึงข้อมูลกลับมา
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.weatherData = "Error: \(error.localizedDescription)"  // แสดงข้อผิดพลาด
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.weatherData = "No data"  // ถ้าไม่ได้รับข้อมูล
                }
                return
            }
            
            // พิมพ์ข้อมูล JSON ที่ได้รับจาก API เพื่อตรวจสอบโครงสร้าง
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")  // พิมพ์ข้อมูล JSON
            }
            
            // พยายามถอดรหัสข้อมูล JSON ที่ได้รับ
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                // อัพเดทข้อมูลสภาพอากาศ
                DispatchQueue.main.async {
                    self.weatherData = "Temp: \(decoded.main.temp)°C, \(decoded.weather.first?.description ?? "Unknown")"
                }
            } catch {
                DispatchQueue.main.async {
                    self.weatherData = "Error decoding data"
                }
            }
        }.resume()  // เริ่มคำขอ HTTP
    }
}

// โมเดลข้อมูลสภาพอากาศจาก OpenWeather API
struct WeatherResponse: Decodable {
    struct Main: Decodable {
        let temp: Double  // อุณหภูมิ
    }
    
    struct Weather: Decodable {
        let description: String  // คำอธิบายสภาพอากาศ (เช่น "Clear sky", "Cloudy")
    }
    
    let main: Main
    let weather: [Weather]  // สภาพอากาศ
}

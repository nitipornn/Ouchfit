//
//  WeatherManager.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 9/5/2568 BE.
//

import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    @Published var dailyForecasts: [Date: Forecast] = [:]
    
    func fetch5DayForecast(lat: Double, lon: Double) {
        let apiKey = "c75267448a9e86641592445cc7e3d66e"
        let urlString =
        "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                
                // เลือกเฉพาะ 1 ชุดข้อมูลต่อวัน (เวลาเที่ยง)
                var tempForecast: [Date: Forecast] = [:]
                let calendar = Calendar.current
                for item in decoded.list {
                    let date = Date(timeIntervalSince1970: item.dt)
                    let hour = calendar.component(.hour, from: date)
                    
                    if hour == 12 {
                        let day = calendar.startOfDay(for: date)
                        tempForecast[day] = item
                    }
                }
                
                DispatchQueue.main.async {
                    self.dailyForecasts = tempForecast
                }
                
            } catch {
                print("Error decoding forecast: \(error)")
            }
        }.resume()
    }
}

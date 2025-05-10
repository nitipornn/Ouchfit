//
//  WeatherModel.swift
//  Ouch!Fit
//
//  Created by Nitiporn Siriwimonwan on 9/5/2568 BE.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let icon: String
}

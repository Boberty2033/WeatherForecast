//
//  WeatherModel.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 21.02.2026.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherDescription]
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherDescription: Codable {
    let description: String
    let icon: String
}

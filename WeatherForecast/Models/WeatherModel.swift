//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import Foundation

// Модель данных для парсинга JSON ответа API
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

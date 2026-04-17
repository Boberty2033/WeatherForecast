//
//  WeatherModel.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 21.02.2026.
//

import Foundation

struct ForecastData: Codable {
    let list: [WeatherList]
    let city: City
}

struct WeatherList: Codable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherInfo]
    let wind: Wind
    let dt_txt: String?
}

struct MainClass: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct WeatherInfo: Codable {
    let description: String
    let icon: String
    let id: Int 
}

struct City: Codable {
    let name: String
    let coord: Coord
}

struct Coord: Codable {
    let lat: Double;
    let lon: Double
}

struct SearchCityModel: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}



struct Wind: Codable {
    let speed: Double
}

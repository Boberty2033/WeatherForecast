//
//  WeatherViewModel.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 13.03.2026.
//

import Foundation
import UIKit

class WeatherViewModel {
    var onUpdate: (() -> Void)?
    
    var cityName: String = ""
    var currentTemp: String = "--°"
    var condition: String = "Обновление..."
    var currentWeatherID: Int = 800
    
    var feelsLike: String = "--"
    var humidity: String = "--"
    var windSpeed: String = "--"
    var pressure: String = "--"
    
    var hourlyForecast: [WeatherList] = []
    var dailyForecast: [WeatherList] = []
    
    private(set) var backgroundColors: [UIColor] = [UIColor(hex: "#5FB8FF"), UIColor(hex: "#A6D8FF")]

    func loadData(for city: String) {
        self.cityName = city
        
        DataManager.shared.fetchWeather(for: city) { [weak self] forecast in
            DispatchQueue.main.async {
                if let forecast = forecast {
                    self?.cityName = forecast.city.name
                    if let current = forecast.list.first {
                        self?.currentTemp = "\(Int(current.main.temp))°"
                        self?.condition = current.weather.first?.description.capitalized ?? ""
                        self?.currentWeatherID = current.weather.first?.id ?? 800
                        
                        self?.feelsLike = "\(Int(current.main.feels_like))°"
                        self?.humidity = "\(current.main.humidity)%"
                        self?.windSpeed = "\(Int(current.wind.speed)) м/с"
                        self?.pressure = "\(current.main.pressure) гПа"
                        
                        
                        let weatherID = current.weather.first?.id ?? 800
                        let theme = WeatherThemeManager.getTheme(id: weatherID)
                        self?.backgroundColors = [theme.topColor, theme.bottomColor]
                    }
                    self?.hourlyForecast = Array(forecast.list.prefix(8))
                    self?.dailyForecast = forecast.list.filter { $0.dt_txt?.contains("12:00:00") ?? false }
                    
                    
                }
                self?.onUpdate?()
            }
        }
    }
}

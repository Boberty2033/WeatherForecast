//
//  WeatherViewModel.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 13.03.2026.
//

import Foundation

class WeatherViewModel {
    
    var onUpdate: (() -> Void)?
    
    private(set) var cityName: String = ""
    private(set) var currentTemp: String = ""
    private(set) var condition: String = ""
    private(set) var currentWeatherID: Int = 800
    
    private(set) var hourlyForecast: [WeatherList] = []
    private(set) var dailyForecast: [WeatherList] = []

    func loadData(for city: String) {
        DataManager.shared.fetchWeather(for: city) { [weak self] forecast in
            guard let self = self, let forecast = forecast else { return }
            
            DispatchQueue.main.async {
                self.cityName = forecast.city.name
                
                if let current = forecast.list.first {
                    self.currentTemp = "\(Int(current.main.temp))°"
                    self.condition = current.weather.first?.description.capitalized ?? ""
                    self.currentWeatherID = current.weather.first?.id ?? 800
                }
                
                self.hourlyForecast = Array(forecast.list.prefix(8))
                
                self.dailyForecast = forecast.list.filter { $0.dt_txt?.contains("12:00:00") ?? false }
                
                self.onUpdate?()
            }
        }
    }
}
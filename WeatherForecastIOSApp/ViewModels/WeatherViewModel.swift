//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 13.03.2026.
//

import Foundation

class WeatherViewModel {
    var onDataUpdate: (() -> Void)?
    
    private(set) var cityName: String = "--"
    private(set) var temperature: String = "--°C"
    
    func fetchWeather(for city: String) {
        NetworkManager.shared.getWeather(city: city) { [weak self] result in
            switch result {
            case .success(let weatherData):
                self?.cityName = weatherData.name
                self?.temperature = "\(Int(weatherData.main.temp))°C"
                self?.onDataUpdate?()
            case .failure(let error):
                print("Ошибка загрузки данных: \(error)")
            }
        }
    }
}
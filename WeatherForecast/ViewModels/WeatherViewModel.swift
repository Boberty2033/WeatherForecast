//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import Foundation

class WeatherViewModel {
    // Замыкание для уведомления View об обновлении данных
    var onDataUpdate: (() -> Void)?
    
    private(set) var cityName: String = "--"
    private(set) var temperature: String = "--°C"
    
    // Запрос данных через сетевой менеджер
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

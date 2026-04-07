//
//  DataManager.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 07.04.2026.
//


import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}

    func fetchWeather(for city: String, completion: @escaping (ForecastData?) -> Void) {
        if let cachedJSON = CoreDataManager.shared.getCachedWeather(for: city) {
            let forecast = try? JSONDecoder().decode(ForecastData.self, from: cachedJSON)
            completion(forecast)
        }

        NetworkManager.shared.fetchForecast(city: city) { forecast in
            guard let forecast = forecast else { return }
            
            if let encodedData = try? JSONEncoder().encode(forecast) {
                CoreDataManager.shared.saveWeather(city: city, data: encodedData)
            }
            completion(forecast)
        }
    }
    
    func addCity(_ name: String) {
        CoreDataManager.shared.ensureCityExists(name: name)
        NotificationCenter.default.post(name: NSNotification.Name("CityListChanged"), object: nil)
    }

    func deleteCity(_ name: String) {
        CoreDataManager.shared.deleteCity(name: name)
        NotificationCenter.default.post(name: NSNotification.Name("CityListChanged"), object: nil)
    }
}

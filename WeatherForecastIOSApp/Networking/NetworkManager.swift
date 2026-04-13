//
//  NetworkManager.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 21.02.2026.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    
    private let apiKey = "c07441d0c9c37a2e03a72aec0acfe852"

    func fetchForecast(city: String, completion: @escaping (ForecastData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric&lang=ru"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let forecast = try? JSONDecoder().decode(ForecastData.self, from: data)
            DispatchQueue.main.async {
                completion(forecast)
            }
        }.resume()
    }
    
    func findCities(name: String, completion: @escaping ([SearchCityModel]) -> Void) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(name)&limit=5&appid=\(apiKey)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            let cities = try? JSONDecoder().decode([SearchCityModel].self, from: data)
            DispatchQueue.main.async {
                completion(cities ?? [])
            }
        }.resume()
    }
    
    func fetchWeatherByCoords(lat: Double, lon: Double, completion: @escaping (ForecastData?) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=ru"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let forecast = try JSONDecoder().decode(ForecastData.self, from: data)
                DispatchQueue.main.async {
                    completion(forecast)
                }
            } catch {
                print("DEBUG: Ошибка парсинга по координатам: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    

}

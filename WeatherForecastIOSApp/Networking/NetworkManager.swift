//
//  NetworkManager.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 21.02.2026.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "c07441d0c9c37a2e03a72aec0acfe852"
    
    private init() {}

    func getWeather(city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                completion(.success(weather))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
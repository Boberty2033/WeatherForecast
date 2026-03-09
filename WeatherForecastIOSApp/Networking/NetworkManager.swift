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
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let forecast = try decoder.decode(ForecastData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(forecast)
                }
            } catch {
                print("Decoding error: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
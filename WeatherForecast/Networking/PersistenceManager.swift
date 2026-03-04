//
//  PersistenceManager.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private let defaults = UserDefaults.standard
    private let cityKey = "last_city"

    // Сохранение последнего выбранного города
    func saveLastCity(_ cityName: String) {
        defaults.set(cityName, forKey: cityKey)
    }

    // Получение последнего города для офлайн режима
    func fetchLastCity() -> String? {
        return defaults.string(forKey: cityKey)
    }
}

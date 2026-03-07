//
//  WeatherIconManager.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 07.04.2026.
//

import UIKit

struct WeatherIconManager {
    static func getIconConfig(id: Int) -> (name: String, color: UIColor) {
        switch id {
        case 200...232:
            return ("cloud.bolt.fill", .systemYellow)
        case 300...321:
            return ("cloud.drizzle.fill", .systemTeal)
        case 500...531:
            return ("cloud.rain.fill", .systemBlue)
        case 600...622:
            return ("snow", .white)
        case 701...781:
            return ("cloud.fog.fill", .lightGray)
        case 800:
            return ("sun.max.fill", .systemYellow)
        case 801:
            return ("cloud.sun.fill", .systemYellow)
        case 802...804:
            return ("cloud.fill", .white)
        default:
            return ("cloud.fill", .white)
        }
    }
}

//
//  WeatherThemeManager.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 17.04.2026.
//

import UIKit

struct WeatherTheme {
    let topColor: UIColor
    let bottomColor: UIColor
}

struct WeatherThemeManager {
    static func getTheme(id: Int) -> WeatherTheme {
        switch id {
        case 200...232:
            return WeatherTheme(topColor: UIColor(hex: "#4B617A"), bottomColor: UIColor(hex: "#202E3C"))
        case 300...531:
            return WeatherTheme(topColor: UIColor(hex: "#516C7B"), bottomColor: UIColor(hex: "#2B3A45"))
        case 600...622:
            return WeatherTheme(topColor: UIColor(hex: "#83ADB3"), bottomColor: UIColor(hex: "#E0F4F6"))
        case 701...781:
            return WeatherTheme(topColor: UIColor(hex: "#7F8C8D"), bottomColor: UIColor(hex: "#BDC3C7"))
        case 800:
            return WeatherTheme(topColor: UIColor(hex: "#5FB8FF"), bottomColor: UIColor(hex: "#A6D8FF"))
        case 801...804:
            return WeatherTheme(topColor: UIColor(hex: "#6291B5"), bottomColor: UIColor(hex: "#93B5D3"))
        default:
            return WeatherTheme(topColor: UIColor(hex: "#5FB8FF"), bottomColor: UIColor(hex: "#A6D8FF"))
        }
    }
}

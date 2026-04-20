//
//  WeatherAnnotation.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 20.04.2026.
//

import MapKit

class WeatherAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let temperature: String
    let minMax: String
    let weatherID: Int
    let isCurrentLocation: Bool

    init(coordinate: CLLocationCoordinate2D, title: String?, temperature: String, minMax: String, weatherID: Int, isCurrentLocation: Bool = false) {
            self.coordinate = coordinate
            self.title = title
            self.temperature = temperature
            self.minMax = minMax
            self.weatherID = weatherID
            self.isCurrentLocation = isCurrentLocation
        }
    }

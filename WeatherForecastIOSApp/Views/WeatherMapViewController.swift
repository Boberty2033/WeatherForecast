//
//  WeatherMapViewController.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 19.04.2026.
//

import UIKit
import MapKit
import CoreLocation

class WeatherMapViewController: UIViewController, MKMapViewDelegate {
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var cities = CoreDataManager.shared.fetchSavedCityNames()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Карта погоды"
        view.backgroundColor = .systemBackground
        
        setupMapView()
        loadMarkers()
    }

    private func setupMapView() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mapView.register(WeatherAnnotationView.self, forAnnotationViewWithReuseIdentifier: WeatherAnnotationView.identifier)
        
        let config = MKStandardMapConfiguration(emphasisStyle: .muted)
        config.pointOfInterestFilter = .excludingAll
        config.showsTraffic = false
        mapView.preferredConfiguration = config
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(close))
        
        mapView.showsUserLocation = false
    }

    private func loadMarkers() {
        if let userLoc = locationManager.location {
            NetworkManager.shared.fetchWeatherByCoords(lat: userLoc.coordinate.latitude, lon: userLoc.coordinate.longitude) { [weak self] forecast in
                guard let forecast = forecast else { return }
                self?.addWeatherAnnotation(from: forecast, isCurrent: true, coords: userLoc.coordinate, shouldZoom: true)
            }
        }

        for (index, city) in cities.enumerated() {
            DataManager.shared.fetchWeather(for: city) { [weak self] forecast in
                guard let self = self, let forecast = forecast else { return }
                let coords = CLLocationCoordinate2D(latitude: forecast.city.coord.lat, longitude: forecast.city.coord.lon)
                
                let shouldZoomOnFirst = (self.locationManager.location == nil && index == 0)
                self.addWeatherAnnotation(from: forecast, isCurrent: false, coords: coords, shouldZoom: shouldZoomOnFirst)
            }
        }
    }

    private func addWeatherAnnotation(from forecast: ForecastData, isCurrent: Bool, coords: CLLocationCoordinate2D, shouldZoom: Bool) {
        guard let current = forecast.list.first else { return }
        
        let minMaxStr = "H:\(Int(current.main.temp_max))° L:\(Int(current.main.temp_min))°"
        let annotation = WeatherAnnotation(
            coordinate: coords,
            title: isCurrent ? "Моё место" : forecast.city.name,
            temperature: "\(Int(current.main.temp))°",
            minMax: minMaxStr,
            weatherID: current.weather.first?.id ?? 800,
            isCurrentLocation: isCurrent
        )
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            
            if shouldZoom {
                let region = MKCoordinateRegion(center: coords, latitudinalMeters: 60000, longitudinalMeters: 60000)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }

    @objc private func close() { dismiss(animated: true) }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let weatherAnno = annotation as? WeatherAnnotation else { return nil }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: WeatherAnnotationView.identifier)
        if view == nil {
            view = WeatherAnnotationView(annotation: weatherAnno, reuseIdentifier: WeatherAnnotationView.identifier)
        } else {
            view?.annotation = weatherAnno
        }
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation is WeatherAnnotation else { return }
    }
}

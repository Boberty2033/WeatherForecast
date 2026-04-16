//
//  WeatherPageViewController.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 12.04.2026.
//

import UIKit
import CoreLocation

class WeatherPageViewController: UIPageViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var currentCity: String?
    
    var favoriteCities = [String]()
    var controllers = [WeatherCardViewController]()
    
    private let bottomBar = UIView()
    private let pageControl = UIPageControl()
    private let listBtn = UIButton(type: .system)
    private let searchBtn = UIButton(type: .system)
    private let mapBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        view.backgroundColor = .black
        
        setupBottomBar()
        loadAndSetup()
        
        if let firstVC = controllers.first {
            setViewControllers([firstVC], direction: .forward, animated: false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: NSNotification.Name("CityListChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCitySelection(_:)), name: NSNotification.Name("CitySelected"), object: nil)
        
        setupLocation()
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let city = placemarks?.first?.locality {
                self?.currentCity = city
                self?.handleUpdate()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomBar.applyGradient(colors: [UIColor(hex: "#1BB0F0").withAlphaComponent(0.9),
                                         UIColor(hex: "#0F658A").withAlphaComponent(0.9)])
    }

    private func setupBottomBar() {
        view.addSubview(bottomBar)
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        mapBtn.setImage(UIImage(systemName: "map"), for: .normal)
        mapBtn.addTarget(self, action: #selector(mapTapped), for: .touchUpInside)
        
        listBtn.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listBtn.addTarget(self, action: #selector(listTapped), for: .touchUpInside)
        
        searchBtn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        
        [mapBtn, listBtn, searchBtn].forEach { $0.tintColor = .white }
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .white.withAlphaComponent(0.3)
        
        [mapBtn, pageControl, searchBtn, listBtn].forEach {
            bottomBar.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 90),
            
            mapBtn.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 20),
            mapBtn.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 20),
            mapBtn.widthAnchor.constraint(equalToConstant: 40),
            mapBtn.heightAnchor.constraint(equalToConstant: 40),
            
            pageControl.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 20),
            
            listBtn.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -20),
            listBtn.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 20),
            listBtn.widthAnchor.constraint(equalToConstant: 40),
            listBtn.heightAnchor.constraint(equalToConstant: 40),
            
            searchBtn.trailingAnchor.constraint(equalTo: listBtn.leadingAnchor, constant: -20),
            searchBtn.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 20),
            searchBtn.widthAnchor.constraint(equalToConstant: 40),
            searchBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func loadAndSetup() {
        var citiesFromDB = CoreDataManager.shared.fetchSavedCityNames()
        
        if let gpsCity = currentCity {
            citiesFromDB.removeAll { $0 == gpsCity }
            citiesFromDB.insert(gpsCity, at: 0)
        }
        
        favoriteCities = citiesFromDB
        controllers = favoriteCities.map { city in
            let vc = WeatherCardViewController()
            vc.cityName = city
            return vc
        }
        pageControl.numberOfPages = controllers.count
    }

    @objc func handleUpdate() {
            loadAndSetup()
            self.dataSource = nil
            self.dataSource = self
            
            if let firstVC = controllers.first {
                setViewControllers([firstVC], direction: .forward, animated: false)
                pageControl.currentPage = 0
            }
    }

    @objc private func listTapped() {
        let listVC = CityListViewController()
        present(UINavigationController(rootViewController: listVC), animated: true)
    }
    
    @objc private func searchTapped() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        present(UINavigationController(rootViewController: searchVC), animated: true)
    }
    
    @objc private func mapTapped() {
        let mapVC = WeatherMapViewController()
        present(UINavigationController(rootViewController: mapVC), animated: true)
    }

    @objc func handleCitySelection(_ notification: Notification) {
        guard let cityName = notification.object as? String,
              let index = favoriteCities.firstIndex(of: cityName) else { return }
        setViewControllers([controllers[index]], direction: .forward, animated: true)
        pageControl.currentPage = index
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherCardViewController, let index = controllers.firstIndex(of: vc), index > 0 else { return nil }
        return controllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherCardViewController, let index = controllers.firstIndex(of: vc), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = viewControllers?.first as? WeatherCardViewController, let index = controllers.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
    }
}

extension WeatherPageViewController: SearchViewControllerDelegate {
    func didSelectCity(_ city: String) {
        let currentCities = CoreDataManager.shared.fetchSavedCityNames()
        
        if !currentCities.contains(where: { $0.lowercased() == city.lowercased() }) {
            DataManager.shared.addCity(city)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.loadAndSetup()
                self.dataSource = nil
                self.dataSource = self
                
                if let lastVC = self.controllers.last {
                    self.setViewControllers([lastVC], direction: .forward, animated: true)
                    self.pageControl.currentPage = self.controllers.count - 1
                }
            }
        }
    }
}

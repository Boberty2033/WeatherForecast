//
//  WeatherPageViewController.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 12.04.2026.
//

import UIKit

class WeatherPageViewController: UIPageViewController {
    
    var favoriteCities = CoreDataManager.shared.fetchSavedCityNames()
    var controllers = [WeatherCardViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .black
        
        setupControllers()
    }

    func setupControllers() {
        controllers.removeAll()
        for city in favoriteCities {
            let vc = WeatherCardViewController()
            vc.cityName = city
            controllers.append(vc)
        }
        
        if let firstVC = controllers.first {
            setViewControllers([firstVC], direction: .forward, animated: false)
        }
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherCardViewController,
              let index = controllers.firstIndex(of: vc), index > 0 else { return nil }
        return controllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? WeatherCardViewController,
              let index = controllers.firstIndex(of: vc), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }
}
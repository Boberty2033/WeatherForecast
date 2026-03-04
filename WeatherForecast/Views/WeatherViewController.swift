//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import UIKit

class WeatherViewController: UIViewController {
    private let viewModel = WeatherViewModel()
    
    // Элементы интерфейса (верстка кодом)
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let forecastTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchWeather(for: "Moscow")
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Погода"
        // Здесь будет детальная настройка Auto Layout (SnapKit или NSLayoutConstraints)
    }

    private func bindViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.cityLabel.text = self?.viewModel.cityName
                self?.temperatureLabel.text = self?.viewModel.temperature
                self?.forecastTableView.reloadData()
            }
        }
    }
}

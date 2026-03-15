//
//  WeatherCardViewController.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 04.03.2026.
//

import UIKit

class WeatherCardViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = WeatherViewModel()
    
    // MARK: - UI Elements
    private let backgroundView = UIView()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureUI()
        
        bindViewModel()
        
        viewModel.loadData(for: "Moscow")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.applyGradient(colors: [
            UIColor(red: 0.37, green: 0.72, blue: 1.00, alpha: 1.0),
            UIColor(red: 0.65, green: 0.85, blue: 1.00, alpha: 1.0)
        ])
    }

    // MARK: - Binding
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.cityLabel.text = self?.viewModel.cityName
                self?.temperatureLabel.text = self?.viewModel.currentTemp
            }
        }
    }

    private func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)

        [backgroundView, cityLabel, temperatureLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureUI() {
        cityLabel.font = .systemFont(ofSize: 40, weight: .bold)
        cityLabel.textColor = .white
        cityLabel.applyShadow()

        temperatureLabel.font = .systemFont(ofSize: 80, weight: .thin)
        temperatureLabel.textColor = .white
        temperatureLabel.applyShadow()
    }
}
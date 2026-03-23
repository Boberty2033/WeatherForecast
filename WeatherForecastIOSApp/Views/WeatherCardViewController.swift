//
//  WeatherCardViewController.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 04.03.2026.
//

import UIKit

class WeatherCardViewController: UIViewController {

    private let viewModel = WeatherViewModel()
    
    // MARK: - UI Elements
    private let backgroundView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let hourlyCard = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var hourlyCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureHeader()
        setupHourlyCollection()
        bindViewModel()
        
        viewModel.loadData(for: "Moscow")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.applyGradient(colors: [UIColor(hex: "#5FB8FF"), UIColor(hex: "#A6D8FF")])
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.cityLabel.text = self?.viewModel.cityName
                self?.temperatureLabel.text = self?.viewModel.currentTemp
                self?.descriptionLabel.text = self?.viewModel.condition
                
                self?.hourlyCollectionView.reloadData()
            }
        }
    }

    private func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backgroundView, scrollView, contentView, cityLabel, temperatureLabel, descriptionLabel, hourlyCard].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentView.addSubview(cityLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(hourlyCard)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            cityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            hourlyCard.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            hourlyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hourlyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hourlyCard.heightAnchor.constraint(equalToConstant: 150),
            
            hourlyCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func configureHeader() {
        cityLabel.font = .systemFont(ofSize: 34, weight: .medium)
        temperatureLabel.font = .systemFont(ofSize: 90, weight: .thin)
        descriptionLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        [cityLabel, temperatureLabel, descriptionLabel].forEach {
            $0.textColor = .white
            $0.applyShadow()
        }
    }

    private func setupHourlyCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 100)
        
        hourlyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hourlyCollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        
        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourlyCard.contentView.addSubview(hourlyCollectionView)
        
        NSLayoutConstraint.activate([
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyCard.topAnchor),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: hourlyCard.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: hourlyCard.trailingAnchor),
            hourlyCollectionView.bottomAnchor.constraint(equalTo: hourlyCard.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: viewModel.hourlyForecast[indexPath.item])
        return cell
    }
}
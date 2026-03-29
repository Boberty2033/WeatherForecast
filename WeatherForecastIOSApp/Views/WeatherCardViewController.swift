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
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let hourlyCard = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var hourlyCollectionView: UICollectionView!
    
    private let dailyCard = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let dailyTableView = UITableView()
    private let dailyHeaderLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        configureHeader()
        setupHourlyCollection()
        setupDailyTable()
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
                self?.tempLabel.text = self?.viewModel.currentTemp
                self?.descriptionLabel.text = self?.viewModel.condition
                
                self?.hourlyCollectionView.reloadData()
                self?.dailyTableView.reloadData()
            }
        }
    }

    private func setupLayout() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backgroundView, scrollView, contentView, cityLabel, tempLabel, descriptionLabel, hourlyCard, dailyCard].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(hourlyCard)
        contentView.addSubview(dailyCard)

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

            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            hourlyCard.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            hourlyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hourlyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hourlyCard.heightAnchor.constraint(equalToConstant: 150),
            
            dailyCard.topAnchor.constraint(equalTo: hourlyCard.bottomAnchor, constant: 20),
            dailyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dailyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dailyCard.heightAnchor.constraint(equalToConstant: 350),
            
            dailyCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func setupDailyTable() {
        dailyHeaderLabel.text = "Прогноз на неделю"
        dailyHeaderLabel.font = .systemFont(ofSize: 18, weight: .bold)
        dailyHeaderLabel.textColor = .white.withAlphaComponent(0.8)
        dailyHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyCard.contentView.addSubview(dailyHeaderLabel)
        
        dailyTableView.register(DailyTableViewCell.self, forCellReuseIdentifier: DailyTableViewCell.identifier)
        dailyTableView.dataSource = self
        dailyTableView.backgroundColor = .clear
        dailyTableView.isScrollEnabled = false
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        dailyCard.contentView.addSubview(dailyTableView)
        
        NSLayoutConstraint.activate([
            dailyHeaderLabel.topAnchor.constraint(equalTo: dailyCard.topAnchor, constant: 15),
            dailyHeaderLabel.leadingAnchor.constraint(equalTo: dailyCard.leadingAnchor, constant: 20),
            
            dailyTableView.topAnchor.constraint(equalTo: dailyHeaderLabel.bottomAnchor, constant: 10),
            dailyTableView.leadingAnchor.constraint(equalTo: dailyCard.leadingAnchor),
            dailyTableView.trailingAnchor.constraint(equalTo: dailyCard.trailingAnchor),
            dailyTableView.bottomAnchor.constraint(equalTo: dailyCard.bottomAnchor, constant: -10)
        ])
    }
    
}

// MARK: - DataSources
extension WeatherCardViewController: UICollectionViewDataSource, UITableViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: viewModel.hourlyForecast[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
        cell.configure(with: viewModel.dailyForecast[indexPath.row])
        return cell
    }
}
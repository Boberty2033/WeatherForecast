//
//  WeatherCardViewController.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 04.03.2026.
//

import UIKit

class WeatherCardViewController: UIViewController {
    
    var cityName: String = ""
    var isPreview: Bool = false
    var onAddCity: ((String) -> Void)?

    private let previewBar = UIView()
    private let addBtn = UIButton(type: .system)
    private let cancelBtn = UIButton(type: .system)
    private let viewModel = WeatherViewModel()
    
    // MARK: - UI Elements
    private let backgroundView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    
    private let headerStack = UIStackView()
    
    private let hourlyCard = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let dailyCard = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private var hourlyCollectionView: UICollectionView!
    private let dailyTableView = UITableView()
    private let dailyHeaderLabel = UILabel()
    
    
    private let detailsCard = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let feelsLikeValue = UILabel()
    private let humidityValue = UILabel()
    private let windValue = UILabel()
    private let pressureValue = UILabel()
    
    
    private var currentBgColors: [UIColor] = [UIColor(hex: "#5FB8FF"), UIColor(hex: "#A6D8FF")]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupPreviewBar()
        bindViewModel()
        
        cityLabel.text = cityName
        viewModel.loadData(for: cityName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.applyGradient(colors: currentBgColors)
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                if let newColors = self?.viewModel.backgroundColors {
                    self?.currentBgColors = newColors
                    self?.backgroundView.applyGradient(colors: newColors)
                }
                
                self?.cityLabel.text = self?.viewModel.cityName
                self?.tempLabel.text = self?.viewModel.currentTemp
                self?.descriptionLabel.text = self?.viewModel.condition
                self?.hourlyCollectionView.reloadData()
                self?.dailyTableView.reloadData()
                
                
                self?.feelsLikeValue.text = self?.viewModel.feelsLike
                self?.humidityValue.text = self?.viewModel.humidity
                self?.windValue.text = self?.viewModel.windSpeed
                self?.pressureValue.text = self?.viewModel.pressure
                
                self?.hourlyCollectionView.reloadData()
                self?.dailyTableView.reloadData()
                
                
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
        
        [backgroundView, scrollView, contentView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        
        setupHeaderUI()
        
        setupCardsUI()
        
        
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupHeaderUI() {
        
        [cityLabel, tempLabel, descriptionLabel].forEach {
            if $0.superview == nil {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.textColor = .white
                $0.textAlignment = .center
                $0.applyShadow()
                contentView.addSubview($0)
            }
        }

        cityLabel.font = .systemFont(ofSize: 48, weight: .bold)
        tempLabel.font = .systemFont(ofSize: 100, weight: .thin)
        descriptionLabel.font = .systemFont(ofSize: 24, weight: .medium)

        
        cityLabel.removeConstraints(cityLabel.constraints)
        tempLabel.removeConstraints(tempLabel.constraints)
        descriptionLabel.removeConstraints(descriptionLabel.constraints)

        NSLayoutConstraint.activate([
            
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.widthAnchor.constraint(equalTo: view.widthAnchor),

            
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: -10),
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),

            
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: -10),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func setupCardsUI() {
        [hourlyCard, dailyCard].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 25
            $0.clipsToBounds = true
        }
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 130)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        hourlyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hourlyCollectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        hourlyCard.contentView.addSubview(hourlyCollectionView)
        
        
        dailyHeaderLabel.text = "Прогноз на 5 дней"
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
        
        
        
        contentView.addSubview(detailsCard)
        detailsCard.translatesAutoresizingMaskIntoConstraints = false
        detailsCard.layer.cornerRadius = 25
        detailsCard.clipsToBounds = true
        
        let row1 = UIStackView(arrangedSubviews: [
            createDetailItem(title: "Ощущается как", valueLabel: feelsLikeValue),
            createDetailItem(title: "Влажность", valueLabel: humidityValue)
        ])
        let row2 = UIStackView(arrangedSubviews: [
            createDetailItem(title: "Ветер", valueLabel: windValue),
            createDetailItem(title: "Давление", valueLabel: pressureValue)
        ])
        
        [row1, row2].forEach {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
        }
        
        let mainGrid = UIStackView(arrangedSubviews: [row1, row2])
        mainGrid.axis = .vertical
        mainGrid.spacing = 20
        mainGrid.distribution = .fillEqually
        mainGrid.translatesAutoresizingMaskIntoConstraints = false
        detailsCard.contentView.addSubview(mainGrid)
        
        NSLayoutConstraint.activate([
            
           
                hourlyCard.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
                hourlyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                hourlyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                hourlyCard.heightAnchor.constraint(equalToConstant: 160),
                
                hourlyCollectionView.topAnchor.constraint(equalTo: hourlyCard.topAnchor),
                hourlyCollectionView.leadingAnchor.constraint(equalTo: hourlyCard.leadingAnchor),
                hourlyCollectionView.trailingAnchor.constraint(equalTo: hourlyCard.trailingAnchor),
                hourlyCollectionView.bottomAnchor.constraint(equalTo: hourlyCard.bottomAnchor),
                
                dailyCard.topAnchor.constraint(equalTo: hourlyCard.bottomAnchor, constant: 20),
                dailyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                dailyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                dailyCard.heightAnchor.constraint(equalToConstant: 400),
                
                dailyHeaderLabel.topAnchor.constraint(equalTo: dailyCard.topAnchor, constant: 15),
                dailyHeaderLabel.leadingAnchor.constraint(equalTo: dailyCard.leadingAnchor, constant: 20),
                
                dailyTableView.topAnchor.constraint(equalTo: dailyHeaderLabel.bottomAnchor, constant: 10),
                dailyTableView.leadingAnchor.constraint(equalTo: dailyCard.leadingAnchor),
                dailyTableView.trailingAnchor.constraint(equalTo: dailyCard.trailingAnchor),
                dailyTableView.bottomAnchor.constraint(equalTo: dailyCard.bottomAnchor, constant: -10),
                

                detailsCard.topAnchor.constraint(equalTo: dailyCard.bottomAnchor, constant: 20),
                detailsCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                detailsCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                detailsCard.heightAnchor.constraint(equalToConstant: 160),
                
                mainGrid.topAnchor.constraint(equalTo: detailsCard.contentView.topAnchor, constant: 20),
                mainGrid.leadingAnchor.constraint(equalTo: detailsCard.contentView.leadingAnchor, constant: 20),
                mainGrid.trailingAnchor.constraint(equalTo: detailsCard.contentView.trailingAnchor, constant: -20),
                mainGrid.bottomAnchor.constraint(equalTo: detailsCard.contentView.bottomAnchor, constant: -20),

                detailsCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -120)
            
        ])
    }
    
    private func setupPreviewBar() {
            previewBar.isHidden = !isPreview
            if !isPreview { return }
            
            view.addSubview(previewBar)
            previewBar.translatesAutoresizingMaskIntoConstraints = false
            
            cancelBtn.setTitle("Cancel", for: .normal)
            cancelBtn.setTitleColor(.white, for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
            
            addBtn.setTitle("Add", for: .normal)
            addBtn.setTitleColor(.white, for: .normal)
            addBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            addBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
            
            [cancelBtn, addBtn].forEach {
                previewBar.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            NSLayoutConstraint.activate([
                previewBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                previewBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                previewBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                previewBar.heightAnchor.constraint(equalToConstant: 50),
                
                cancelBtn.leadingAnchor.constraint(equalTo: previewBar.leadingAnchor, constant: 20),
                cancelBtn.centerYAnchor.constraint(equalTo: previewBar.centerYAnchor),
                
                addBtn.trailingAnchor.constraint(equalTo: previewBar.trailingAnchor, constant: -20),
                addBtn.centerYAnchor.constraint(equalTo: previewBar.centerYAnchor)
            ])
        }

    @objc private func cancelTapped() { dismiss(animated: true) }
    
    @objc private func addTapped() {
        onAddCity?(cityName)
        dismiss(animated: true)
    }
    
    private func createDetailItem(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title.uppercased()
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
        titleLabel.textColor = .white.withAlphaComponent(0.6)
        
        valueLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        valueLabel.textColor = .white
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }
}

// MARK: - Extensions
extension WeatherCardViewController: UICollectionViewDataSource, UITableViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as? HourlyCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.hourlyForecast[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as? DailyTableViewCell else { return UITableViewCell() }
        cell.configure(with: viewModel.dailyForecast[indexPath.row])
        return cell
    }
}



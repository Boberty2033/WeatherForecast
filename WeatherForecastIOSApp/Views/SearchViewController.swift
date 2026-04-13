//
//  SearchViewController.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 13.04.2026.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectCity(_ city: String)
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: SearchViewControllerDelegate?
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let noResultsView = UIView()
    private let noResultsLabel = UILabel()
    private let noResultsIcon = UIImageView()
    
    private var results = [SearchCityModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupNoResultsView()
    }

    private func setupUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Поиск города..."
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelTapped))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupNoResultsView() {
        noResultsView.translatesAutoresizingMaskIntoConstraints = false
        noResultsView.isHidden = true
        view.addSubview(noResultsView)
        
        noResultsIcon.image = UIImage(systemName: "magnifyingglass")
        noResultsIcon.tintColor = .systemGray3
        noResultsIcon.contentMode = .scaleAspectFit
        
        noResultsLabel.text = "Результатов нет"
        noResultsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        noResultsLabel.textColor = .systemGray
        noResultsLabel.textAlignment = .center
        
        [noResultsIcon, noResultsLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            noResultsView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            noResultsIcon.centerXAnchor.constraint(equalTo: noResultsView.centerXAnchor),
            noResultsIcon.topAnchor.constraint(equalTo: noResultsView.topAnchor),
            noResultsIcon.widthAnchor.constraint(equalToConstant: 60),
            noResultsIcon.heightAnchor.constraint(equalToConstant: 60),
            
            noResultsLabel.topAnchor.constraint(equalTo: noResultsIcon.bottomAnchor, constant: 10),
            noResultsLabel.leadingAnchor.constraint(equalTo: noResultsView.leadingAnchor, constant: 20),
            noResultsLabel.trailingAnchor.constraint(equalTo: noResultsView.trailingAnchor, constant: -20),
            noResultsLabel.bottomAnchor.constraint(equalTo: noResultsView.bottomAnchor)
        ])
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    // MARK: - Search Logic
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            noResultsView.isHidden = true
            activityIndicator.startAnimating()
            
            NetworkManager.shared.findCities(name: searchText) { [weak self] cities in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.results = cities
                    self?.tableView.reloadData()
                    self?.noResultsView.isHidden = !cities.isEmpty
                }
            }
        } else {
            results = []
            tableView.reloadData()
            noResultsView.isHidden = true
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = results[indexPath.row]
        let stateInfo = city.state != nil ? ", \(city.state!)" : ""
        cell.textLabel?.text = "\(city.name)\(stateInfo), \(city.country)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = results[indexPath.row]
        let previewVC = WeatherCardViewController()
        previewVC.cityName = selectedCity.name
        previewVC.isPreview = true
        
        previewVC.onAddCity = { [weak self] name in
            self?.delegate?.didSelectCity(name)
        }
        present(previewVC, animated: true)
    }
}

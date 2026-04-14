//
//  CityListViewController.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 14.04.2026.
//

import UIKit

class CityListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cities = [String]()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранные города"
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            cities = CoreDataManager.shared.fetchSavedCityNames()
            tableView.reloadData()
        }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(close))
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }

    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        
        
        var content = cell.defaultContentConfiguration()
        content.text = cities[indexPath.row]
        content.textProperties.color = .label
        cell.contentConfiguration = content
        
        cell.backgroundColor = .clear
        return cell
    }

    // MARK: - Удаление строк
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cityToRemove = cities[indexPath.row]
            
            DataManager.shared.deleteCity(cityToRemove)
            
            cities.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            NotificationCenter.default.post(name: NSNotification.Name("CityListChanged"), object: nil)
        }
    }
    
    // MARK: - Переход к городу при нажатии
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        
        
        NotificationCenter.default.post(name: NSNotification.Name("CitySelected"), object: selectedCity)
        
        dismiss(animated: true)
    }
}

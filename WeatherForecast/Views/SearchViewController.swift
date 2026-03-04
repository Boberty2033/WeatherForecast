//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by Alexander Dolgikh on 21.01.2026.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    private let searchBar = UISearchBar()
    private let resultsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        setupLayout()
    }

    private func setupLayout() {
        // Логика размещения строки поиска и таблицы результатов
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text else { return }
        // Вызов логики поиска города
        dismiss(animated: true)
    }
}

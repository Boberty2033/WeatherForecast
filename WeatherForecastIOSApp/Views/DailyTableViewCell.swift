//
//  DailyTableViewCell.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 27.04.2026.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    static let identifier = "DailyTableViewCell"
    
    private let dayLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [dayLabel, iconView, tempLabel])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        dayLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        iconView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tempLabel.textAlignment = .right
        
        dayLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tempLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        [dayLabel, tempLabel].forEach {
            $0.textColor = .white
            $0.applyShadow()
        }
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.applyShadow()
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with model: WeatherList) {
        let date = Date(timeIntervalSince1970: TimeInterval(model.dt))
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        
        if Calendar.current.isDateInToday(date) {
            dayLabel.text = "Сегодня"
        } else {
            formatter.dateFormat = "EEEE"
            dayLabel.text = formatter.string(from: date).capitalized
        }
        
        tempLabel.text = "\(Int(model.main.temp))°"
        
        if let weatherID = model.weather.first?.id {
            let config = WeatherIconManager.getIconConfig(id: weatherID)
            iconView.image = UIImage(systemName: config.name)
            iconView.tintColor = config.color
        }
    }
}

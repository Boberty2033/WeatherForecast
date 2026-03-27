//
//  HourlyCollectionViewCell.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 19.04.2026.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyCollectionViewCell"
    
    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconView, tempLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        
        timeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tempLabel.font = .systemFont(ofSize: 20, weight: .bold)
        [timeLabel, tempLabel].forEach {
            $0.textColor = .white
            $0.applyShadow()
        }
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.applyShadow()
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 35),
            iconView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func configure(with model: WeatherList) {
        let date = Date(timeIntervalSince1970: TimeInterval(model.dt))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: date)
        
        tempLabel.text = "\(Int(model.main.temp))°"
        
        
        if let weatherID = model.weather.first?.id {
            let config = WeatherIconManager.getIconConfig(id: weatherID)
            
            
            iconView.image = UIImage(systemName: config.name)
            iconView.tintColor = config.color
        }
    }
}

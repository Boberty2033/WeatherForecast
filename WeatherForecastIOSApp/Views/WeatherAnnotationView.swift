//
//  WeatherAnnotationView.swift
//  WeatherForecastIOSApp
//
//  Created by Alexander Dolgikh on 20.04.2026.
//

import MapKit

class WeatherAnnotationView: MKAnnotationView {
    static let identifier = "WeatherAnnotationView"
    
    private let containerView = UIView()
    private let tempLabel = UILabel()
    private let minMaxLabel = UILabel()
    private let iconView = UIImageView()
    private let stackView = UIStackView()
    
    private var widthConstraint: NSLayoutConstraint?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        self.backgroundColor = .clear
        
        containerView.backgroundColor = UIColor(hex: "#5FB8FF")
        containerView.layer.cornerRadius = 22.5
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        tempLabel.font = .systemFont(ofSize: 14, weight: .bold)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        
        minMaxLabel.font = .systemFont(ofSize: 10, weight: .medium)
        minMaxLabel.textColor = .white.withAlphaComponent(0.9)
        minMaxLabel.isHidden = true
        
        iconView.contentMode = .scaleAspectFit
        iconView.isHidden = true
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackValueAlignment()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(minMaxLabel)
        stackView.addArrangedSubview(tempLabel)
        stackView.addArrangedSubview(iconView)
        
        containerView.addSubview(stackView)
        
        widthConstraint = containerView.widthAnchor.constraint(equalToConstant: 45)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 45),
            widthConstraint!,
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 25),
            iconView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func stackValueAlignment() {
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.minMaxLabel.isHidden = !selected
        self.iconView.isHidden = !selected
        self.widthConstraint?.constant = selected ? 140 : 45
        self.containerView.layer.cornerRadius = selected ? 15 : 22.5
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        guard let weatherAnno = annotation as? WeatherAnnotation else { return }
        tempLabel.text = weatherAnno.temperature
        minMaxLabel.text = weatherAnno.minMax
        let config = WeatherIconManager.getIconConfig(id: weatherAnno.weatherID)
        iconView.image = UIImage(systemName: config.name)
        iconView.tintColor = .white
    }
}

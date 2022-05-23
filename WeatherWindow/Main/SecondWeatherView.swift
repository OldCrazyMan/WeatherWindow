//
//  SecoundWeatherView.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation
import UIKit

protocol SearchProtocol: AnyObject {
    func searchButtonTapped()
}

class SecondWeatherView: UIView {
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .specialDay
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "editing")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addShadowOnView()
        return button
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic48()
        label.textColor = .specialText
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoBold48()
        label.textColor = .specialText
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addShadowOnView()
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic22()
        label.textColor = .specialText
        label.textAlignment = .center
        label.text = "Для поиска"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic22()
        label.textColor = .specialText
        label.textAlignment = .center
        label.text = "нажмите на иконку "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var minMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic22()
        label.textColor = .specialText
        label.textAlignment = .center
        label.text = "вверху экрана"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowOnView()
        return view
    }()
    
    private var hourlyCollectionView = HourlyCollectionView()
    private var dailyTableView = DailyTableView()
    
    weak var searchButtonDelegate: SearchProtocol?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        networkManager()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        addSubview(backgroundView)
        
        backgroundView.addSubview(searchButton)
        backgroundView.addSubview(weatherImageView)
        backgroundView.addSubview(cityLabel)
        backgroundView.addSubview(tempLabel)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(minMaxLabel)
        backgroundView.addSubview(feelsLikeLabel)
    }
    
    private func networkManager() {
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.setParameters(weatherModel: currentWeather)
        }
    }
    
    @objc private func searchButtonTapped() {
        searchButtonDelegate?.searchButtonTapped()
    }
    
    //MARK: - SetParameters
    
    func setParameters(weatherModel: CurrentWeather) {
        DispatchQueue.main.async {
            
            self.setBackgroundColor(icon: weatherModel.icon)
            self.backgroundColor = self.backgroundView.backgroundColor
            self.descriptionLabel.text = weatherModel.weatherDescription.capitalizingFirstLetter()
            self.minMaxLabel.text = "Мин.:\(weatherModel.tempMin)º, мaкс.:\(weatherModel.tempMax)º"
            self.weatherImageView.image = UIImage(named: weatherModel.icon)
            self.cityLabel.text = weatherModel.cityName
            self.tempLabel.text = "\(weatherModel.temperatureString)°C"
            self.feelsLikeLabel.text = "Ощущается как \(weatherModel.feelsLikeTemperatureString)"
        }
    }
    
    private func setBackgroundColor(icon: String){
        switch icon {
        case "01d":
            backgroundView.backgroundColor = .specialDay
        case "02d", "03d", "04d", "unknown":
            backgroundView.backgroundColor = .specialCloudyDay
        case "09d","09n", "10d","10n", "13d", "13n":
            backgroundView.backgroundColor = .specialRainyDay
        case "50d":
            backgroundView.backgroundColor = .specialWind
        case "01n", "02n", "03n", "04n":
            backgroundView.backgroundColor = .specialNight
        case "11d", "11n":
            backgroundView.backgroundColor = .specialThunderstorm
        case "50n":
            backgroundView.backgroundColor = .specialWindNight
        default:
            print("error")
        }
    }
    
    //MARK: - SetContraints
    
    private func setContraints() {
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
        backgroundView.contentHuggingPriority(for: .vertical)
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            searchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.bottomAnchor.constraint(equalTo: cityLabel.topAnchor, constant: 10),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 150),
            weatherImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            feelsLikeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            feelsLikeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            feelsLikeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            minMaxLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: 10),
            minMaxLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            minMaxLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}


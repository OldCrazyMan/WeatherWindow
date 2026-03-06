//
//  SecoundWeatherView.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit
import AVFoundation

protocol SearchProtocol: AnyObject {
    func searchButtonTapped()
}

class SecondWeatherView: UIView {
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer?
    private var playerLooper: AVPlayerLooper?
    private var playerItem: AVPlayerItem?
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = .RobotoThinItalic(48)
        label.textColor = .specialIcon
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.font = .robotoBold(48)
        label.textColor = .specialIcon
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic(24)
        label.textColor = .specialIcon
        label.textAlignment = .center
        label.text = "Для ПОИСКА"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic(24)
        label.textColor = .specialIcon
        label.textAlignment = .center
        label.text = "нажмите на иконку"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var minMaxLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic(24)
        label.textColor = .specialIcon
        label.textAlignment = .center
        label.text = "сверху экрана"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowOnView()
        return view
    }()
    
    private var videoView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var searchButtonDelegate: SearchProtocol?
    weak var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        networkManager()
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .specialWind
        
        addSubview(backgroundView)
        addSubview(searchButton)
        
        backgroundView.addSubview(weatherImageView)
        addSubview(cityLabel)
        addSubview(tempLabel)
        addSubview(descriptionLabel)
        addSubview(minMaxLabel)
        addSubview(feelsLikeLabel)
        backgroundView.addSubview(videoView)
    }
    
    private func networkManager() {
        NetworkManager.shared.onCompletion = { [weak self] currentWeather in
            DispatchQueue.main.async {
                self?.setParameters(weatherModel: currentWeather)
            }
        }
        
        NetworkManager.shared.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        searchButtonDelegate?.searchButtonTapped()
    }
    
    func setParameters(weatherModel: CurrentWeather) {
        UIView.animate(withDuration: 0.8) {
            self.backgroundView.alpha = 1
        }
        
        setBackgroundColor(icon: weatherModel.icon)
        backgroundColor = backgroundView.backgroundColor
        configWeatherVideo(icon: weatherModel.icon)
        descriptionLabel.text = weatherModel.weatherDescription.capitalizingFirstLetter()
        minMaxLabel.text = "Мин.:\(weatherModel.tempMin)º, макс.:\(weatherModel.tempMax)º"
        weatherImageView.image = UIImage(named: weatherModel.icon)
        cityLabel.text = weatherModel.cityName
        tempLabel.text = "\(weatherModel.temperatureString)°C"
        feelsLikeLabel.text = "Ощущается как \(weatherModel.feelsLikeTemperatureString)"
    }
    
    private func configWeatherVideo(icon: String) {
        guard let path = Bundle.main.path(forResource: icon, ofType: "mp4") else { return }
        
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        playerLayer?.videoGravity = .resizeAspectFill
        playerLooper = AVPlayerLooper(player: player as! AVQueuePlayer, templateItem: playerItem!)
        
        videoView.layer.addSublayer(playerLayer!)
        playerLayer?.frame = videoView.bounds
        player.play()
        
        UIView.animate(withDuration: 1, delay: 0.3) {
            self.videoView.alpha = 0.75
        }
    }
    
    private func setBackgroundColor(icon: String) {
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
            backgroundView.backgroundColor = .specialDay
        }
    }
    
    private func setContraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.heightAnchor.constraint(equalToConstant: 70),
            
            videoView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            videoView.heightAnchor.constraint(equalToConstant: 230),
            
            weatherImageView.bottomAnchor.constraint(equalTo: cityLabel.topAnchor, constant: 20),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 150),
            weatherImageView.heightAnchor.constraint(equalToConstant: 150),
            
            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            tempLabel.widthAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            feelsLikeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            feelsLikeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            feelsLikeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            minMaxLabel.topAnchor.constraint(equalTo: feelsLikeLabel.bottomAnchor, constant: 10),
            minMaxLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            minMaxLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

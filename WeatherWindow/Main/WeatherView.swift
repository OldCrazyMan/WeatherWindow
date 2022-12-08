//
//  WeatherView.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation
import UIKit
import AVFoundation

class WeatherView: UIScrollView {
    
    private var player : AVPlayer!
    private var playerLayer : AVPlayerLayer?
    private var playerLooper: AVPlayerLooper?
    private var playerItem: AVPlayerItem?
    
    private var backgroundView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic48()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "Пожалуйста, подождите..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WeatherBack")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic48()
        label.textColor = .specialText
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = " "
        label.addShadowOnView()
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
        label.numberOfLines = 2
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addShadowOnView()
        return label
    }()
    
    private var maxMinLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic22()
        label.textColor = .specialText
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = " "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.addShadowOnView()
        return label
    }()
    
    private var videoView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var hourlyCollectionView = HourlyCollectionView()
    private var dailyTableView = DailyTableView()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSelfScrollView()
        setupViews()
        setContraints()
        addShadowOnView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        
        addSubview(weatherImageView)
        addSubview(loadingLabel)
        addSubview(backgroundView)
        backgroundView.addSubview(videoView)
        backgroundView.addSubview(cityLabel)
        backgroundView.addSubview(tempLabel)
        backgroundView.addSubview(descriptionLabel)
        backgroundView.addSubview(maxMinLabel)
        backgroundView.addSubview(hourlyCollectionView)
        backgroundView.addSubview(dailyTableView)
    }
    
    func configureSelfScrollView(){
        self.bounces = false
        self.contentInsetAdjustmentBehavior = .never
        self.showsVerticalScrollIndicator = false
        backgroundColor = .specialIcon
    }
    
    //MARK: - SetParameters
    
    func setParameters(weatherModel: CurrentWeatherViewModel) {

        DispatchQueue.main.async {
            self.loadingLabel.alpha = 0
            self.weatherImageView.alpha = 0
            
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.allowUserInteraction], animations:
                            { () -> Void in
                self.backgroundView.alpha = 1 })
            
            self.setBackgroundColor(icon: weatherModel.icon)
            self.backgroundColor = self.backgroundView.backgroundColor
            self.configWeatherVideo(icon: weatherModel.icon)
            self.cityLabel.text = weatherModel.locality
            self.tempLabel.text = weatherModel.temp
            self.descriptionLabel.text = weatherModel.weatherDescription.capitalizingFirstLetter()
            self.maxMinLabel.text = weatherModel.maxMinTemp
            
            self.hourlyCollectionView.frame = CGRect(x: 0,
                                                     y: self.maxMinLabel.frame.maxY + 30,
                                                     width: self.frame.width,
                                                     height: 165)
            
            self.hourlyCollectionView.setWeather(cells: weatherModel.hourlyWeather)
            
            self.dailyTableView.frame = CGRect(x: 10,
                                               y: self.hourlyCollectionView.frame.maxY,
                                               width: self.frame.width - 20,
                                               height: DailyTableView.cellHeight * 8)
            self.dailyTableView.setWeather(cells: weatherModel.dailyWeather)
            
        }
    }
    
    private func configWeatherVideo(icon: String){
        
        guard let path = Bundle.main.path(forResource: icon, ofType:"mp4") else { return }
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: self.player)
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLooper = AVPlayerLooper(player: self.player as! AVQueuePlayer, templateItem: self.playerItem!)
        
        videoView.layer.addSublayer(self.playerLayer!)
        self.playerLayer?.frame = self.videoView.bounds
        self.player.play()
        UIView.animate(withDuration: 1, delay: 0.3, options: [.allowUserInteraction], animations:
                        { () -> Void in
            self.videoView.alpha = 0.75
        })
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
        
        backgroundView.contentHuggingPriority(for: .vertical)
        
        NSLayoutConstraint.activate([
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.heightAnchor.constraint(equalTo: heightAnchor),
            weatherImageView.widthAnchor.constraint(equalTo: widthAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            loadingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor, constant: 30),
            cityLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            cityLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 10),
            cityLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -10),
            
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            tempLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            maxMinLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            maxMinLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            maxMinLabel.heightAnchor.constraint(equalToConstant: 18),
            
            videoView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            videoView.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
}

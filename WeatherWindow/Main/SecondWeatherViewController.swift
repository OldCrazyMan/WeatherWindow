//
//  SecoundWeatherViewController.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit

class SecondWeatherViewController: UIViewController {
    
    private let weatherView = SecondWeatherView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
    }
    
    private func setupViews() {
        view.addSubview(weatherView)
        weatherView.frame = view.frame
        weatherView.viewController = self
    }
    
    private func setDelegates() {
        weatherView.searchButtonDelegate = self
    }
}

//MARK: - SearchProtocol

extension SecondWeatherViewController: SearchProtocol {
    func searchButtonTapped() {
        self.presentSearchAlertConroller(
            withTitle: "Поиск города",
            message: "Введите название города (например: Moscow)",
            style: .alert
        ) { city in
            NetworkManager.shared.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
}

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
        weatherView.frame = self.view.frame
    }
    
    private func setDelegates() {
        weatherView.searchButtonDelegate = self
    }
}

//MARK: - SearchProtocol

extension SecondWeatherViewController: SearchProtocol {
    func searchButtonTapped() {
        self.presentSearchAlertConroller(withTitle: "Пожалуйста, введите название города в формате 'Ulyanovsk'",
                                         message: nil,
                                         style: .alert) { city in
            NetworkManager.shared.fetchCurrentWeather(forRequestType: .cityName(city: city))
        }
    }
}


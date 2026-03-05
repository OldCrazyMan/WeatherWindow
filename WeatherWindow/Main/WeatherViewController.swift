//
//  WeatherViewController.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit
import CoreLocation

protocol WeatherDisplayLogic: AnyObject {
    func displayData(viewModel: WeatherEnum.Model.ViewModel.ViewModelData)
}

class WeatherViewController: UIViewController, WeatherDisplayLogic {
    
    var interactor: WeatherBusinessLogic?
    private let weatherView = WeatherView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interactor?.requestData(request: .getWeather)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        weatherView.contentSize = CGSize(width: view.bounds.width, height: 840)
    }
    
    private func setupViews() {
        let presenter = WeatherPresenter()
        let interactor = WeatherInteractor()
        
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
        
        view.addSubview(weatherView)
        weatherView.frame = view.frame
    }
    
    func displayData(viewModel: WeatherEnum.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displayWeather(let currentWeatherViewModel):
            weatherView.setParameters(weatherModel: currentWeatherViewModel)
            
        case .displayError(let message):
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

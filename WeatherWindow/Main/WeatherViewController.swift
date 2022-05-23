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
        
        weatherView.contentSize = CGSize(width:self.view.bounds.width, height: 840)
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        let viewController = self
        
        let presenter  = WeatherPresenter()
        let interactor = WeatherInteractor()
        
        viewController.interactor = interactor
        interactor.presenter  = presenter
        presenter.viewController = viewController
        
        view.addSubview(weatherView)
        weatherView.frame = self.view.frame
    }
    
    //MARK: - DisplayData
    
    func displayData(viewModel: WeatherEnum.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayWeather(let currentWeatherViewModel):
            weatherView.setParameters(weatherModel: currentWeatherViewModel)
        }
    }
}

//
//  WeatherInteractor.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit
import CoreLocation

protocol WeatherBusinessLogic {
    func requestData(request: WeatherEnum.Model.Request.RequestType)
}

class WeatherInteractor: NSObject, WeatherBusinessLogic, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var presenter: WeatherPresentationLogic?
    var networkManager = NetworkRequest()
    
    //MARK: - RequestData
    
    func requestData(request: WeatherEnum.Model.Request.RequestType) {
        
        switch request {
        case .getWeather:
            getLocation()
        }
    }
    
    private func getLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - LocationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        let coordinates = "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
        guard let currentLocation = locationManager.location else { return }
        
        geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: Locale.init(identifier: "ru_RU")) { placemarks, error in
            let locality = placemarks?[0].locality ?? (placemarks?[0].name ?? "Error")
            
            self.locationManager.stopUpdatingLocation()
            
            self.networkManager.getWeather(coordinates: coordinates) { weatherResponse in
                guard let weatherResponse = weatherResponse else { return }
                self.presenter?.presentData(response: .presentWeather(weather: weatherResponse, locality: locality))
                
            }
        }
    }
}

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
    var networkService: NetworkServiceProtocol = NetworkService()
    
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
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        guard let currentLocation = locationManager.location else { return }
        
        geocoder.reverseGeocodeLocation(currentLocation, preferredLocale: Locale.init(identifier: "ru_RU")) { placemarks, error in
            if error != nil {
                self.presenter?.presentData(response: .presentError("Ошибка определения города"))
                return
            }
            
            let locality = placemarks?[0].locality ?? (placemarks?[0].name ?? "Неизвестно")
            
            Task {
                do {
                    let forecast = try await self.networkService.fetchForecast(lat: lat, lon: lon)
                    let weatherResponse = self.convertToWeatherResponse(forecast: forecast)
                    
                    await MainActor.run {
                        self.presenter?.presentData(response: .presentWeather(weather: weatherResponse, locality: locality))
                    }
                    
                } catch NetworkError.serverError {
                    await MainActor.run {
                        self.presenter?.presentData(response: .presentError("Сервер временно недоступен"))
                    }
                } catch NetworkError.decodingError {
                    await MainActor.run {
                        self.presenter?.presentData(response: .presentError("Ошибка обработки данных"))
                    }
                } catch {
                    await MainActor.run {
                        self.presenter?.presentData(response: .presentError("Ошибка загрузки погоды"))
                    }
                }
            }
        }
    }
    
    private func convertToWeatherResponse(forecast: WeatherModels.ForecastResponse) -> WeatherResponse {
        
        let current = Current(
            dt: Date().timeIntervalSince1970,
            temp: forecast.current.tempC,
            weather: [
                WeatherInfo(
                    description: forecast.current.condition.text,
                    icon: mapIcon(forecast.current.condition.icon)
                )
            ]
        )
        
        var hourly: [HourlyWeather] = []
        if let today = forecast.forecast.forecastday.first {
            for hour in today.hour.prefix(24) {
                hourly.append(HourlyWeather(
                    dt: dateToTimestamp(hour.time),
                    temp: hour.tempC,
                    weather: [
                        HourlyWeatherInfo(
                            description: hour.condition.text,
                            icon: mapIcon(hour.condition.icon)
                        )
                    ]
                ))
            }
        }
        
        let daily = forecast.forecast.forecastday.map { day in
            DailyWeather(
                dt: dateToTimestamp(day.date + " 12:00"),
                temp: DailyTemp(min: day.day.mintempC, max: day.day.maxtempC),
                weather: [
                    DailyWeatherInfo(icon: mapIcon(day.day.condition.icon))
                ]
            )
        }
        
        return WeatherResponse(
            lat: forecast.location.lat,
            lon: forecast.location.lon,
            current: current,
            hourly: hourly,
            daily: daily
        )
    }
    
    private func mapIcon(_ iconUrl: String) -> String {
        let isDay = iconUrl.contains("day")
        
        if iconUrl.contains("113") {
            return isDay ? "01d" : "01n"
        }
        
        if iconUrl.contains("116") {
            return isDay ? "02d" : "02n"
        }
        
        if iconUrl.contains("119") || iconUrl.contains("122") {
            if iconUrl.contains("122") {
                return isDay ? "04d" : "04n"
            } else {
                return isDay ? "03d" : "03n"
            }
        }
        
        if iconUrl.contains("143") || iconUrl.contains("248") || iconUrl.contains("260") {
            return isDay ? "50d" : "50n"
        }
        
        if iconUrl.contains("293") || iconUrl.contains("296") || iconUrl.contains("299") || iconUrl.contains("302") || iconUrl.contains("305") || iconUrl.contains("308") {
            return isDay ? "10d" : "10n"
        }
        
        if iconUrl.contains("176") || iconUrl.contains("311") || iconUrl.contains("314") || iconUrl.contains("317") {
            return isDay ? "09d" : "09n"
        }
        
        if iconUrl.contains("320") || iconUrl.contains("323") || iconUrl.contains("326") || iconUrl.contains("329") || iconUrl.contains("332") || iconUrl.contains("335") || iconUrl.contains("338") || iconUrl.contains("350") || iconUrl.contains("368") || iconUrl.contains("371") {
            return isDay ? "13d" : "13n"
        }
        
        if iconUrl.contains("386") || iconUrl.contains("389") || iconUrl.contains("392") || iconUrl.contains("395") {
            return isDay ? "11d" : "11n"
        }
        
        print("Неизвестная иконка WeatherAPI: \(iconUrl)")
        return "unknown"
    }
    
    private func dateToTimestamp(_ dateString: String) -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = formatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }
        
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            return date.timeIntervalSince1970
        }
        
        return Date().timeIntervalSince1970
    }
}

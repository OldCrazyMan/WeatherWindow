//
//  WeatherPresenter.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit

protocol WeatherPresentationLogic {
    func presentData(response: WeatherEnum.Model.Response.ResponseType)
}

class WeatherPresenter: WeatherPresentationLogic {
    
    weak var viewController: WeatherDisplayLogic?
    
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        return dt
    }()
    
    func presentData(response: WeatherEnum.Model.Response.ResponseType) {
        
        switch response {
            
        case .presentWeather(let weather, let locality):
            var hourlyCells: [CurrentWeatherViewModel.Hourly] = []
            var dailyCells: [CurrentWeatherViewModel.Daily] = []
            
            for hourly in weather.hourly {
                hourlyCells.append(CurrentWeatherViewModel.Hourly(
                    dt: formattedDate(dateFormat: "HH", date: hourly.dt),
                    temp: setSign(temp: Int(hourly.temp)),
                    description: hourly.weather.first?.description ?? "",
                    icon: hourly.weather.first?.icon ?? "unknown"
                ))
            }
            
            if !hourlyCells.isEmpty {
                if hourlyCells.count > 24 {
                    hourlyCells = Array(hourlyCells.prefix(24))
                }
                hourlyCells[0].dt = "Сейчас"
            }
            
            for daily in weather.daily {
                dailyCells.append(CurrentWeatherViewModel.Daily(
                    dt: formattedDate(dateFormat: "EEEE", date: daily.dt),
                    minTemp: setSign(temp: Int(daily.temp.min)),
                    maxTemp: setSign(temp: Int(daily.temp.max)),
                    icon: daily.weather.first?.icon ?? "unknown"
                ))
            }
            
            if !dailyCells.isEmpty {
                dailyCells[0].dt = "Сегодня"
                let maxMinTemp = "Мин.: \(dailyCells[0].minTemp), макс.: \(dailyCells[0].maxTemp)"
                
                let currentWeather = headerViewModel(
                    weatherModel: weather,
                    hourlyCells: hourlyCells,
                    maxMinTemp: maxMinTemp,
                    dailyCells: dailyCells,
                    locality: locality
                )
                
                viewController?.displayData(viewModel: .displayWeather(currentWeatherViewModel: currentWeather))
            }
            
        case .presentError(let message):
            viewController?.displayData(viewModel: .displayError(message))
        }
    }
    
    private func formattedDate(dateFormat: String, date: Double) -> String {
        dateFormatter.dateFormat = dateFormat
        let currentDate = Date(timeIntervalSince1970: date)
        return dateFormatter.string(from: currentDate).capitalizingFirstLetter()
    }
    
    private func setSign(temp: Int) -> String {
        guard temp >= 1 else { return "\(temp)º" }
        return "+\(temp)º"
    }
    
    private func headerViewModel(weatherModel: WeatherResponse,
                                 hourlyCells: [CurrentWeatherViewModel.Hourly],
                                 maxMinTemp: String,
                                 dailyCells: [CurrentWeatherViewModel.Daily],
                                 locality: String) -> CurrentWeatherViewModel {
        return CurrentWeatherViewModel(
            locality: locality,
            temp: setSign(temp: Int(weatherModel.current.temp)),
            weatherDescription: weatherModel.current.weather.first?.description ?? "",
            icon: weatherModel.current.weather.first?.icon ?? "unknown",
            hourlyWeather: hourlyCells,
            maxMinTemp: maxMinTemp,
            dailyWeather: dailyCells
        )
    }
}

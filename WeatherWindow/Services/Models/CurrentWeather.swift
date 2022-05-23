//
//  CurrentWeather.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        String(format: "%.0f", temperature)
    }
    
    let tempMin: Double
    let tempMax: Double
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        "\(feelsLikeTemperature.rounded())"
    } 
    
    let icon: String
    let weatherDescription: String

    init?(currentWeatherData: CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        icon = currentWeatherData.weather.first!.icon
        weatherDescription = currentWeatherData.weather.first!.weatherDescription
        tempMin = currentWeatherData.main.tempMin.rounded()
        tempMax = currentWeatherData.main.tempMax.rounded()
    }
}

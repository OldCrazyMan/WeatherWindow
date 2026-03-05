//
//  WeatherModels.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit

enum WeatherEnum {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getWeather
            }
        }
        
        struct Response {
            enum ResponseType {
                case presentWeather(weather: WeatherResponse, locality: String)
                case presentError(String)
            }
        }
        
        struct ViewModel {
            enum ViewModelData {
                case displayWeather(currentWeatherViewModel: CurrentWeatherViewModel)
                case displayError(String)
            }
        }
    }
}
struct CurrentWeatherViewModel {
    let locality: String
    let temp: String
    let weatherDescription: String
    let icon: String
    let hourlyWeather: [Hourly]
    let maxMinTemp: String
    let dailyWeather: [Daily]
    
    struct Hourly{
        var dt: String
        let temp: String
        let description: String
        let icon: String
    }
    
    struct Daily{
        var dt: String
        let minTemp: String
        let maxTemp: String
        let icon: String
    }
}

enum WeatherModels {
    
    // MARK: - Current Weather Response
    struct CurrentWeatherResponse: Codable {
        let location: Location
        let current: Current
    }
    
    // MARK: - Forecast Response
    struct ForecastResponse: Codable {
        let location: Location
        let current: Current
        let forecast: Forecast
    }
    
    // MARK: - Common Models
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let localtime: String
    }
    
    struct Current: Codable {
        let tempC: Double
        let condition: Condition
        let windKph: Double
        let windDir: String
        let pressureMb: Double
        let humidity: Int
        let cloud: Int
        let feelslikeC: Double
        let visKm: Double
        
        enum CodingKeys: String, CodingKey {
            case tempC = "temp_c"
            case condition
            case windKph = "wind_kph"
            case windDir = "wind_dir"
            case pressureMb = "pressure_mb"
            case humidity
            case cloud
            case feelslikeC = "feelslike_c"
            case visKm = "vis_km"
        }
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
        let code: Int
    }
    
    struct Forecast: Codable {
        let forecastday: [ForecastDay]
    }
    
    struct ForecastDay: Codable {
        let date: String
        let day: Day
        let hour: [Hour]
    }
    
    struct Day: Codable {
        let maxtempC: Double
        let mintempC: Double
        let condition: Condition
        
        enum CodingKeys: String, CodingKey {
            case maxtempC = "maxtemp_c"
            case mintempC = "mintemp_c"
            case condition
        }
    }
    
    struct Hour: Codable {
        let time: String
        let tempC: Double
        let condition: Condition
        
        enum CodingKeys: String, CodingKey {
            case time
            case tempC = "temp_c"
            case condition
        }
    }
}

//
//  NetworkManager.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation

class NetworkManager {
    enum RequestType {
        case cityName(city: String)
    }
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            urlString =
            "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(API.apiKey)&lang=ru&units=metric"
        }
        performRequest(withURLString: urlString)
    }
    
    private func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
   private func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData)
            else { return nil }
            return currentWeather
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}

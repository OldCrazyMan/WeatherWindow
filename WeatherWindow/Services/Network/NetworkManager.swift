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
    var onError: ((String) -> Void)?
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchCurrentWeather(forRequestType requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityName(let city):
            let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=26243dc4e99183020fb80271c9f19faf&lang=ru&units=metric"
        }
        
        performRequest(withURLString: urlString)
    }
    
    private func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else {
            onError?("Неверный URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.onError?("Ошибка сети: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.onError?("Ошибка сервера")
                }
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        self.onError?("Неверный API ключ")
                    }
                } else if httpResponse.statusCode == 404 {
                    DispatchQueue.main.async {
                        self.onError?("Город не найден")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.onError?("Ошибка сервера: \(httpResponse.statusCode)")
                    }
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.onError?("Нет данных")
                }
                return
            }
            
            if let currentWeather = self.parseJSON(withData: data) {
                DispatchQueue.main.async {
                    self.onCompletion?(currentWeather)
                }
            } else {
                DispatchQueue.main.async {
                    self.onError?("Ошибка обработки данных")
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            return CurrentWeather(currentWeatherData: currentWeatherData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

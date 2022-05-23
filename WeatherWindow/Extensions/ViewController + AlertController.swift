//
//  ViewController + AlertController.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//


import Foundation
import UIKit

extension SecondWeatherViewController {
    
    func presentSearchAlertConroller(withTitle title: String?,
                                     message: String?,
                                     style: UIAlertController.Style,
                                     completionHandler: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField {someCities in
            let cities = ["Moscow", "Ulyanovsk", "Tashkent", "Kaliningrad"]
            someCities.placeholder = cities.randomElement()
        }
        
        let search = UIAlertAction(title: "Найти", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else {return}
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20").capitalizingFirstLetter()
                completionHandler(city)
            } else {
                self.alertOkCancel(title: "", message: "Введите название города в формате 'Ulyanovsk'") {
                    self.dismiss(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(search)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func alertOkCancel(title: String, message: String?, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        }
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}

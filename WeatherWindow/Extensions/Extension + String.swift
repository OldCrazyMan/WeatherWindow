//
//  Extension + String.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

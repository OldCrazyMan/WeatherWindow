//
//  UIFont + Extensions.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit

extension UIFont {
    
    //ThinItalic     
    static func RobotoThinItalic(_ size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Roboto-ThinItalic", size: size)
    }
    
    //Bold
    static func robotoBold(_ size: CGFloat) -> UIFont? {
        return UIFont.init(name: "Roboto-bold", size: size)
    }
}

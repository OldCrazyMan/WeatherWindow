//
//  UIView + Extensions.swift
//  WorkOut
//
//  Created by Тимур Ахметов on 15.02.2022.
//  

import UIKit

extension UIView {
    
    func addShadowOnView() {
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1.0
    }
}

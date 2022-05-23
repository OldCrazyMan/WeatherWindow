//
//  BlurEffectView.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation
import UIKit

class BlurEffect: UIVisualEffectView{
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: UIBlurEffect(style: .dark))
        self.layer.opacity = 0.6
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

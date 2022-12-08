//
//  MainTabBarController.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViews()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .black
        tabBar.alpha = 0.3
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderColor = UIColor.specialGray.cgColor
        tabBar.layer.borderWidth = 0.2
    }
    
    private func setupViews() {
        
        let mainVC = WeatherViewController()
        let mainVC2 = SecondWeatherViewController()
        
        setViewControllers([mainVC, mainVC2], animated: true)
        
        guard let items = tabBar.items else { return }
        
        items[0].image = UIImage(named: "heart")
        items[1].image = UIImage(named: "tabBar")
    }
}

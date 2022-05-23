//
//  HourlyCollectionViewCell.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation
import UIKit

class HourlyCollectionViewCell: UICollectionViewCell{
    
    static let reuseId = "HourlyCollectionViewCell"
    
    private var blurEffectView = BlurEffect()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic18()
        label.textAlignment = .center
        label.textColor = .specialText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .robotoBold20()
        label.textAlignment = .center
        label.textColor = .specialText
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    //MARK: - LayoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        backgroundColor = .clear
        
        contentView.addSubview(blurEffectView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(tempLabel)
    }
    
    //MARK: - ConfigureCell
    
    func configureCell(data: CurrentWeatherViewModel.Hourly) {
        dateLabel.text = data.dt
        weatherImageView.image = UIImage(named: data.icon)
        tempLabel.text = data.temp
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 30),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            tempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            tempLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

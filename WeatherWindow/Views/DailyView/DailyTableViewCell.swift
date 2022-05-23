//
//  DailyTableViewCell.swift
//  WeatherWindow
//
//  Created by Тимур Ахметов on 22.05.2022.
//

import Foundation
import UIKit

class DailyTableViewCell: UITableViewCell {
    
    static let reuseId = "DailyTableViewCell"
    
    private var blurEffectView = BlurEffect()
    
    private var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .RobotoThinItalic18()
        label.textAlignment = .left
        label.textColor = .specialText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var weatherImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var maxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .robotoBold20()
        label.textAlignment = .right
        label.textColor = .specialText
        return label
    }()
    
    private var minLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .robotoBold18()
        label.textAlignment = .right
        label.textColor = .specialGray
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
    
    //MARK: - SetupViews
    
    private func setupViews(){
        backgroundColor = .clear
        
        contentView.addSubview(blurEffectView)
        contentView.addSubview(dayLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(minLabel)
        contentView.addSubview(maxLabel)
    }
    
    //MARK: - ConfigureCell
    
    func configureCell(data: CurrentWeatherViewModel.Daily){
        dayLabel.text = String(data.dt)
        weatherImageView.image = UIImage(named: data.icon)
        minLabel.text = data.minTemp
        maxLabel.text = data.maxTemp
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
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            dayLabel.widthAnchor.constraint(equalToConstant: 120),
            dayLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            weatherImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: maxLabel.leadingAnchor, constant: -18),
            weatherImageView.widthAnchor.constraint(equalToConstant: 30),
            weatherImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            minLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            minLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            minLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            maxLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            maxLabel.trailingAnchor.constraint(equalTo: minLabel.leadingAnchor, constant: -8),
            maxLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

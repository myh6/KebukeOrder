//
//  ShadowsImageButton.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/16.
//

import UIKit

class ShadowsImageButton: UIButton {

  //MARK: - Properties


  //MARK: - Lifecycle
  init(systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, color: UIColor) {
    super.init(frame: .zero)
    var config = UIButton.Configuration.plain()
    config.image = UIImage(systemName: systemName)
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)
    configuration = config
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
    layer.masksToBounds = false
    layer.cornerRadius = 4.0
    tintColor = color
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Helpers

}

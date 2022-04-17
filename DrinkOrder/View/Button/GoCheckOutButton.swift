//
//  AddNewDrinkButton.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/10.
//

import UIKit

class GoCheckOutButton: UIButton {

  //MARK: - Properties
  private var config = UIButton.Configuration.tinted()

  //MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Helpers
  fileprivate func configureUI() {
    heightAnchor.constraint(equalToConstant: 50).isActive = true
    config.baseBackgroundColor = UIColor.white
    config.image = UIImage(systemName: "cart.fill.badge.plus")
    config.imagePlacement = .leading
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
    config.imagePadding = 10
    config.title = "Go to Checkout"
    configuration = config
    tintColor = UIColor(named: "DeepBlueColor") ?? #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    backgroundColor = .white
    layer.cornerRadius = 5
  }

}

//
//  FinishOrderButton.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/10.
//

import UIKit

class SendOrderButton: UIButton {

  //MARK: - Properites
  private var config = UIButton.Configuration.tinted()

  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    heightAnchor.constraint(equalToConstant: 50).isActive = true
    config.baseBackgroundColor = UIColor.systemPink
    config.title = "SEND"
    configuration = config
    tintColor = UIColor(named: "DeepBlueColor") ?? #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    backgroundColor = .white
    layer.cornerRadius = 5
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

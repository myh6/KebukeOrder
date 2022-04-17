//
//  LoginButton.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/15.
//

import UIKit

class LoginButton: UIButton {

  init(title: String, type: ButtonType) {
    super.init(frame: .zero)
    setTitle(title, for: .normal)
    backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
    titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
    titleLabel?.textColor = .white
    layer.cornerRadius = 5
    heightAnchor.constraint(equalToConstant: 50).isActive = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


}

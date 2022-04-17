//
//  DropDownTextField.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/13.
//

import UIKit

class CustomizeTextField: UITextField {

  //MARK: - Properties

  //MARK: - Lifecycle
  init(placeholder: String) {
    super.init(frame: .zero)
    let spacer = UIView()
    spacer.setDimensions(height: 50, width: 12)
    leftView = spacer
    leftViewMode = .always
    borderStyle = .none
    textColor = .white
    backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).withAlphaComponent(0.6)
    heightAnchor.constraint(equalToConstant: 50).isActive = true
    layer.cornerRadius = 5
    attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
      .foregroundColor: UIColor(white: 1, alpha: 0.7)
    ])
    keyboardAppearance = .dark
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


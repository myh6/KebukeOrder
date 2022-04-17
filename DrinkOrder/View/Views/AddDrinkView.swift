//
//  AddDrinkView.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/11.
//

import UIKit

protocol AddDrinkViewDelegate: AnyObject {
  func goToCart()
  func sendNumberOfCup(n: Int)
}

class AddDrinkView: UIView {

  //MARK: - Properties
  private lazy var minusButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = UIImage(systemName: "minus.circle.fill")?.withRenderingMode(.alwaysTemplate)
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
    button.configuration = config
    button.tintColor = UIColor.white
    button.addTarget(self, action: #selector(handleMinusDrink), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()

  private var numberLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    label.text = "1"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()

  private lazy var addButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
    config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
    button.configuration = config
    button.tintColor = UIColor(named: "DeepYelloColor") ?? #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
    button.addTarget(self, action: #selector(handleAddDrink), for: .touchUpInside)
    return button
  }()

  private lazy var addToCartButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = UIColor(named: "DeepYelloColor") ?? #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
    button.layer.cornerRadius = 5
    button.setTitle("Add to Cart", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.addTarget(self, action: #selector(handleGoToCart), for: .touchUpInside)
    return button
  }()

  private var numberOfCup: Int = 1
  weak var delegate: AddDrinkViewDelegate?

  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = frame.height / 7
    backgroundColor = .white
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Actions
  @objc func handleGoToCart() {
    delegate?.sendNumberOfCup(n: numberOfCup)
    delegate?.goToCart()
  }

  @objc func handleMinusDrink() {
    checkMinuButtonStatus()
    numberOfCup -= 1
    numberLabel.text = String(numberOfCup)
    checkMinuButtonStatus()
  }

  @objc func handleAddDrink() {
    checkMinuButtonStatus()
    numberOfCup += 1
    numberLabel.text = String(numberOfCup)
    checkMinuButtonStatus()
  }

  //MARK: - Helpers
  private func configureUI() {
    dropShadow()
    let stack1 = UIStackView(arrangedSubviews: [minusButton, numberLabel, addButton])
    stack1.axis = .horizontal
    stack1.distribution = .fillEqually

    let stack2 = UIStackView(arrangedSubviews: [stack1, addToCartButton])
    stack2.axis = .horizontal
    stack2.distribution = .fillEqually

    self.addSubview(stack2)
    stack2.anchor(left: self.leftAnchor,
                  right: self.rightAnchor,
                  paddingLeft: 10, paddingRight: 10)
    stack2.centerY(inView: self)
  }

  private func checkMinuButtonStatus() {
    minusButton.isEnabled = numberOfCup > 1 ? true : false
    minusButton.tintColor = minusButton.isEnabled ? UIColor(named: "DeepYelloColor") ?? #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1) : UIColor.white
  }


}

//
//  ListForGroupTableViewCell.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/17.
//

import UIKit

class ListForGroupTableViewCell: UITableViewCell {

  //MARK: - Properties
  var drinkNameLabel: UILabel = {
    let label = UILabel()
    label.text = "test"
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    label.numberOfLines = 0
    return label
  }()

  var drinkImage: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "春芽冷露cup")
    iv.layer.cornerRadius = 10
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()

  var drinkPrice: UILabel = {
    let label = UILabel()
    label.text = "$ 20"
    label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    label.textColor = .black
    label.numberOfLines = 1
    return label
  }()

  lazy var infoLable: UILabel = {
    let label = UILabel()
    label.text = "test"
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.numberOfLines = 0
    return label
  }()


  //MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Helpers
  fileprivate func configureUI() {

    backgroundColor = .white
    let infoStack = UIStackView(arrangedSubviews: [drinkNameLabel, infoLable])
    infoStack.axis = .vertical
    infoStack.spacing = 3

    addSubview(drinkImage)
    drinkImage.anchor(left: leftAnchor,
                      paddingTop: 10, paddingLeft: 10)
    drinkImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
    drinkImage.centerY(inView: self)
    drinkImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
    addSubview(drinkPrice)
    drinkPrice.anchor(right: rightAnchor,
                      paddingTop: 10, paddingRight: 10)
    drinkPrice.centerY(inView: self)
    drinkPrice.widthAnchor.constraint(equalToConstant: 80).isActive = true
    addSubview(infoStack)
    infoStack.anchor(left: drinkImage.rightAnchor,
                     right: drinkPrice.leftAnchor,
                     paddingTop: 10,paddingLeft: 10, paddingRight: 10)
    infoStack.centerY(inView: self)
  }


}

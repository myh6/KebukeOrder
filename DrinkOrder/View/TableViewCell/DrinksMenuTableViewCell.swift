//
//  DrinksStackView.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/10.
//

import UIKit

class DrinksMenuTableViewCell: UITableViewCell {

  //MARK: - Properties
  var nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    label.textAlignment = .left
    label.text = "熟成紅茶"
    label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    return label
  }()
  
  var drinkImage: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "熟成紅茶cup")
    img.contentMode = .scaleAspectFill
    img.clipsToBounds = true
    img.layer.cornerRadius = 10
    return img
  }()

  var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    label.text = "解炸物/燒烤肉類油膩，茶味濃郁帶果香"
    label.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    label.numberOfLines = 0
    return label
  }()

  var priceTagLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15)
    label.text = "$30"
    label.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    return label
  }()

  //MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Helpers
  private func configureUI() {

    backgroundColor = .white
    addSubview(nameLabel)
    nameLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                     left: leftAnchor,
                     paddingTop: 20, paddingLeft: 20)

    addSubview(drinkImage)
    drinkImage.anchor(top: safeAreaLayoutGuide.topAnchor,
                      bottom: safeAreaLayoutGuide.bottomAnchor,
                      right: rightAnchor,
                      paddingTop: 10, paddingBottom: 20, paddingRight: 20)
    drinkImage.constrainWidth(80)

    addSubview(descriptionLabel)
    descriptionLabel.anchor(top: nameLabel.bottomAnchor,
                            left: leftAnchor,
                            right: drinkImage.leftAnchor,
                            paddingTop: 3, paddingLeft: 20, paddingRight: 20)

    addSubview(priceTagLabel)
    priceTagLabel.anchor(top: descriptionLabel.bottomAnchor,
                         left: leftAnchor,
                         paddingTop: 3, paddingLeft: 20)
  }


}

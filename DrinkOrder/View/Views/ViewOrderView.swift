//
//  ViewOrderView.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/13.
//

import UIKit

class ViewOrderView: UIView {

  //MARK: - Properties
  private let drinkNameLabel: UILabel = {
    let label = UILabel()
    label.text = "\(TempOrder.drinkName) x\(TempOrder.drinksNumber)"
    label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    label.numberOfLines = 0
    return label
  }()

  private let drinkImage: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "\(TempOrder.drinkName)cuup") ?? #imageLiteral(resourceName: "麗春紅茶cup")
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()

  private let drinkPrice: UILabel = {
    let label = UILabel()
    label.text = "$ \(TempOrder.totalPrice)"
    label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    label.textColor = .black
    label.numberOfLines = 1
    return label
  }()

  private let infoLable: UILabel = {
    let label = UILabel()
    label.text = "\(TempOrder.drinkVariation),\(TempOrder.drinkIceLevel),\(TempOrder.drinkSweetLevel)"

    if TempOrder.addWhitePearl && TempOrder.addWaterPearl {
      label.text?.append(contentsOf: ",白玉珍珠+水玉")
    } else if TempOrder.addWaterPearl && !TempOrder.addWhitePearl {
      label.text?.append(contentsOf: ",水玉")
    } else if TempOrder.addWhitePearl && !TempOrder.addWaterPearl {
      label.text?.append(contentsOf: ",白玉珍珠")
    }
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.numberOfLines = 0
    return label
  }()
  


  

  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Helpers
  private func configureUI() {
    backgroundColor = .white
    layer.cornerRadius = 10

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

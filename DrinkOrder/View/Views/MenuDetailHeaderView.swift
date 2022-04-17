//
//  MenuDetailHeaderView.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/12.
//

import UIKit

class MenuDetailHeaderView: UIView {

  //MARK: - Properites
  var headerImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "冷露歐雷") ?? #imageLiteral(resourceName: "冷露歐雷")
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()

  var headerTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "冷露歐雷"
    label.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
    label.numberOfLines = 1
    return label
  }()

  var headerDetailLabel: UILabel = {
    let label = UILabel()
    label.text = "default"
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    label.font = UIFont.systemFont(ofSize: 15)
    label.numberOfLines = 0
    return label
  }()

  //MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    addSubview(headerImageView)
    headerImageView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
    headerImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

    let stack = UIStackView(arrangedSubviews: [headerTitleLabel, headerDetailLabel])
    stack.axis = .vertical
    stack.distribution = .fillProportionally
    stack.spacing = 10
    addSubview(stack)
    stack.anchor(top: headerImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }



}

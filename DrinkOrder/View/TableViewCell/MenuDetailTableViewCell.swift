//
//  MenuDetailTableViewCell.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/11.
//

import UIKit

class MenuDetailTableViewCell: UITableViewCell {

  //MARK: - Properties
  var optionLabel: UILabel = {
    let label = UILabel()
    label.text = "大"
//    label.textColor = .white
    label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    return label
  }()

  var addValueLabel: UILabel = {
    let label = UILabel()
    label.text = "$35"
//    label.textColor = .white
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
  private func configureUI() {

    backgroundColor = .white
    addSubview(optionLabel)
    optionLabel.anchor(left: leftAnchor, paddingLeft: 20)
    optionLabel.centerY(inView: self)

    addSubview(addValueLabel)
    addValueLabel.anchor(right: rightAnchor, paddingRight: 20)
    addValueLabel.centerY(inView: self)
  }


}

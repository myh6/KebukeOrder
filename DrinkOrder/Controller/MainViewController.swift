//
//  ViewController.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/9.
//

import UIKit

class MainViewController: UIViewController {

  //MARK: - Properties
//  private let addNewDrinkButton = GoCheckOutButton()
  private let topHeaderView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "background")
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()

  private lazy var tableView: UITableView = {
    let tb = UITableView(frame: CGRect.zero, style: .plain)
    tb.register(DrinksMenuTableViewCell.self, forCellReuseIdentifier: "DrinksMenuCell")
    tb.delegate = self
    tb.dataSource = self
    return tb
  }()

  private lazy var logOutButton: UIButton = {
    let button = UIButton()
    button.setTitle("Log Out", for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
    return button
  }()

  private var items = [Item]()

  static var isPopedUp = true
  private let optionButton = ShadowsImageButton(systemName: "ellipsis.circle.fill", pointSize: 50, weight: .bold, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))

  private let listButton = ShadowsImageButton(systemName: "list.bullet.circle.fill", pointSize: 50, weight: .bold, color: UIColor(named: "LightYellowColor") ?? #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))

  private lazy var fullScreenGrayButtonView: UIButton = {
    let button = UIButton()
    button.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    button.backgroundColor = .darkGray.withAlphaComponent(0.8)
    button.addTarget(self, action: #selector(handleTapGray), for: .touchUpInside)
    return button
  }()
  //MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    print("DEBUG: current user is \(Customer.name)")
    configureUI()
    Drinks.shared.getDBMenu { items in
      self.items = items!
    }

  }


  //MARK: - Actions
  @objc func handlePopUpOption() {
    if MainViewController.isPopedUp == true {
      MainViewController.isPopedUp = false

      optionButton.anchor(bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        paddingBottom: 20, paddingRight: 20)
      listButton.anchor(bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        paddingBottom: 20, paddingRight: 20)


      UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: {
        self.view.layoutIfNeeded()
      }, completion: nil)

    } else {
      MainViewController.isPopedUp = true

      optionButton.anchor(bottom: view.bottomAnchor,
                          right: view.rightAnchor,
                          paddingBottom: 20, paddingRight: 20)
      listButton.anchor(bottom: view.bottomAnchor,
                        right: view.rightAnchor,
                        paddingBottom: 100, paddingRight: 20)

      UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
        self.view.layoutIfNeeded()
      }, completion: nil)
    }
    listButton.isHidden = MainViewController.isPopedUp ? false : true
    fullScreenGrayButtonView.isHidden = MainViewController.isPopedUp ? false : true
  }

  @objc func handleLogOut() {
    Customer.clearCustomer()
    TempOrder.clearOrder()
    OrderViewController.harOrderedInList = false
//    self.navigationController?.popToViewController(LoginViewController(), animated: true)
    self.navigationController?.popViewController(animated: true)
  }

  @objc func handleTapGray() {
    MainViewController.isPopedUp = false
    listButton.isHidden = MainViewController.isPopedUp ? false : true
    fullScreenGrayButtonView.isHidden = MainViewController.isPopedUp ? false : true
  }

  @objc func handleGoToList() {
    let nav = UINavigationController(rootViewController: ListViewController())
    nav.modalPresentationStyle = .fullScreen
    self.present(nav, animated: true)
    MainViewController.isPopedUp = false
    listButton.isHidden = MainViewController.isPopedUp ? false : true
    fullScreenGrayButtonView.isHidden = MainViewController.isPopedUp ? false : true
  }
  //MARK: - Helpers
  func configureUI() {

    MainViewController.isPopedUp = false
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black

    view.addSubview(topHeaderView)
    topHeaderView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
    topHeaderView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    view.addSubview(logOutButton)
    logOutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        right: view.rightAnchor,
                        paddingTop: 20, paddingRight: 20)

    view.addSubview(tableView)
    tableView.anchor(top: topHeaderView.bottomAnchor,
                     left: view.leftAnchor,
                     bottom: view.bottomAnchor,
                     right: view.rightAnchor)

    tableView.backgroundColor = UIColor.white

    view.addSubview(fullScreenGrayButtonView)
    fullScreenGrayButtonView.anchor(top: view.topAnchor,
                                    left: view.leftAnchor,
                                    bottom: view.bottomAnchor,
                                    right: view.rightAnchor)

    listButton.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(listButton)
    view.addSubview(optionButton)
    listButton.anchor(bottom: view.bottomAnchor,
                      right: view.rightAnchor,
                      paddingBottom: 20, paddingRight: 20)
    optionButton.anchor(bottom: view.bottomAnchor,
                      right: view.rightAnchor,
                      paddingBottom: 20, paddingRight: 20)
    optionButton.addTarget(self, action: #selector(handlePopUpOption), for: .touchUpInside)
    listButton.addTarget(self, action: #selector(handleGoToList), for: .touchUpInside)

    fullScreenGrayButtonView.isHidden = true
    listButton.isHidden = true
  }

}

//MARK: - Extension
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "飲品"
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    50
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.font = UIFont.systemFont(ofSize: 30)
    header.textLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)

    header.backgroundColor = .white
    header.sizeToFit()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "DrinksMenuCell", for: indexPath) as! DrinksMenuTableViewCell
    let item = items[indexPath.row]
    cell.nameLabel.text = item.name
    cell.drinkImage.image = UIImage(named: "\(item.name)cup")
    cell.descriptionLabel.text = item.description
    cell.priceTagLabel.text = "$\(item.price.medium)"
    cell.selectionStyle = .none
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    if let largePrice = item.price.large {
      let nav = UINavigationController(rootViewController: MenuDetailViewController(drink: DrinksDetail(name: item.name, description: item.description, menu: item.menu, mediumPrice: item.price.medium, largePrice: largePrice)))
      nav.modalPresentationStyle = .popover
      self.present(nav, animated: true)
    } else {
      let nav = UINavigationController(rootViewController: MenuDetailViewController(drink: DrinksDetail(name: item.name, description: item.description, menu: item.menu, mediumPrice: item.price.medium)))
      nav.modalPresentationStyle = .popover
      self.present(nav, animated: true)
    }

  }


}

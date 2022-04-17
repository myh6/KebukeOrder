//
//  MenuDetailViewController.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/11.
//

import UIKit

private let reuseIdentifier = "DrinksMenuCell"

class MenuDetailViewController: UITableViewController {

  //MARK: - Properites
  private let drinksDetail: DrinksDetail

  private lazy var headerTableView = MenuDetailHeaderView()
  private let dismissButton = ShadowsImageButton(systemName: "xmark.circle.fill", pointSize: 25, weight: .bold, color: .white)

  private let addDrinkView = AddDrinkView()
  private let firstSection = ["中", "大"]
  private let secondSection = ["多冰","正常冰","少冰","微冰","去冰","熱"]
  private let thirdSection = ["正常糖","少糖","半糖","微糖","無糖"]
  private let fourthSection = ["白玉珍珠","水玉"]
  private var numberOfCups = 0

  var indexPathOfPreviouslySelectedSection1: IndexPath?
  var indexPathOfPreviouslySelectedSection2: IndexPath?
  var indexPathOfPreviouslySelectedSection3: IndexPath?
  //MARK: - Lifecycle
  init(drink: DrinksDetail) {
    self.drinksDetail = drink
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    print("DEBUG: previousIndex \(String(describing: indexPathOfPreviouslySelectedSection1))")
    view.backgroundColor = .white
    configureUI()

  }

  //MARK: - Actions
  @objc func handleCancel() {
    dismiss(animated: true)
    TempOrder.clearOrder()
  }

  //MARK: - Helpers
  private func configureUI() {
    view.backgroundColor = .white
    let bufferView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150))


    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black

    self.tableView.tableHeaderView = headerTableView
    self.tableView.tableFooterView = bufferView
    self.tableView.separatorStyle = .none

    headerTableView.headerImageView.image = UIImage(named: "\(drinksDetail.name)")
    headerTableView.headerTitleLabel.text = "\(drinksDetail.name)"
    headerTableView.headerDetailLabel.text = "\(drinksDetail.menu)"

    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         paddingTop: 15, paddingLeft: 5)
    dismissButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)

    view.addSubview(addDrinkView)
    addDrinkView.delegate = self
    addDrinkView.anchor(left: view.safeAreaLayoutGuide.leftAnchor,
                        bottom: view.safeAreaLayoutGuide.bottomAnchor,
                        right: view.safeAreaLayoutGuide.rightAnchor,
                        paddingLeft: 20, paddingRight: 20)
    addDrinkView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    addDrinkView.layer.cornerRadius = 10
    addDrinkView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    tableView.register(MenuDetailTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    tableView.allowsMultipleSelection = true
    headerTableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 420)

    view.bringSubviewToFront(addDrinkView)
  }

}

//MARK: - Extension: AddDrinkViewDelegate
extension MenuDetailViewController: AddDrinkViewDelegate {



  func sendNumberOfCup(n: Int) {
    numberOfCups = n
    print("DEBUG: N is \(n)")
  }

  func goToCart() {

    TempOrder.drinkName = drinksDetail.name

    if indexPathOfPreviouslySelectedSection1 == nil {
      self.showAlert(title: "You need to select the cup size of your drink.")
      return
    }
    if indexPathOfPreviouslySelectedSection2 == nil {
      self.showAlert(title: "You need to select the ice level of your drink.")
      return
    }
    if indexPathOfPreviouslySelectedSection3 == nil {
      self.showAlert(title: "You need to select the sweet level of your drink.")
      return
    }

    var price = 0
    if indexPathOfPreviouslySelectedSection1?.row == 0 {
      price = drinksDetail.mediumPrice
    } else {
      price = drinksDetail.largePrice!
    }

    if TempOrder.addWaterPearl {
      print("DEBUG: You want to add 水玉")
      price += 10
    }
    if TempOrder.addWhitePearl {
      print("DEBUG: You want to add 白玉珍珠")
      price += 10
    }
    TempOrder.drinksNumber = numberOfCups
    TempOrder.totalPrice = price * numberOfCups
    print("DEBUG: TOTAL PRICE: \(price * numberOfCups)")
    print("DEBUG: Your ORDER: \(TempOrder.drinkName)")
    print("DEBUG: You want a \(TempOrder.drinkVariation) size")
    print("DEBUG: You want a \(TempOrder.drinkIceLevel) and \(TempOrder.drinkSweetLevel) drink")
    print("-------------------------------------------------------")

    let nav = UINavigationController(rootViewController: OrderViewController())
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true)

  }

}

//MARK: - Extension: TableViewDelegate & TableViewDataSource
extension MenuDetailViewController {

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0: return "Variation"
    case 1: return "冰量Ice level"
    case 2: return "甜度Sweet level"
    case 3: return "加料Add Ingredient"
    default:
      return ""
    }
  }

  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//    tableView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    tableView.backgroundColor = .white
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.textLabel?.font = UIFont.systemFont(ofSize: 30)
    header.textLabel?.textColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    header.sizeToFit()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      if drinksDetail.largePrice?.hashValue != nil {
        return 2
      } else {
        return 1
      }
    case 1: return 6
    case 2: return 5
    case 3:
      return 2
    default:
      return 0
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuDetailTableViewCell
    switch indexPath.section {
    case 0:
      cell.optionLabel.text = firstSection[indexPath.row]
      cell.addValueLabel.text = "$" + String(drinksDetail.mediumPrice)
      if indexPath.row == 1 {
        guard drinksDetail.largePrice != nil else {
          return cell
        }
        cell.optionLabel.text = firstSection[indexPath.row]
        cell.addValueLabel.text = "$" + String(drinksDetail.largePrice!)
      }
    case 1:
      cell.optionLabel.text = secondSection[indexPath.row]
      cell.addValueLabel.text = "+ $0"
    case 2:
      cell.optionLabel.text = thirdSection[indexPath.row]
      cell.addValueLabel.text = "+ $0"
    case 3:
      if indexPath.row <= 2 {
        cell.optionLabel.text = fourthSection[indexPath.row]
        cell.addValueLabel.text = "+ $10"
      }
    default:
      cell.optionLabel.text = "default"
      cell.addValueLabel.text = "+ $0"
      cell.optionLabel.isHidden = true
      cell.addValueLabel.isHidden = true
    }
    return cell
  }

  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    switch indexPath.section {
    case 0:
      if indexPathOfPreviouslySelectedSection1 == indexPath {
        indexPathOfPreviouslySelectedSection1 = nil
        TempOrder.drinkVariation = ""
      }
    case 1:
      if indexPathOfPreviouslySelectedSection2 == indexPath {
        indexPathOfPreviouslySelectedSection2 = nil
        TempOrder.drinkIceLevel = ""
      }
    case 2:
      if indexPathOfPreviouslySelectedSection3 == indexPath {
        indexPathOfPreviouslySelectedSection3 = nil
        TempOrder.drinkSweetLevel = ""
      }
    case 3:
        if indexPath.row == 0 {
          TempOrder.addWhitePearl = false
        } else {
          TempOrder.addWaterPearl = false
        }
    default:
      break
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch indexPath.section {
    case 0:
      if let previousIndexPath = indexPathOfPreviouslySelectedSection1 {
        tableView.deselectRow(at: previousIndexPath, animated: false)
        }
      indexPathOfPreviouslySelectedSection1 = indexPath
      TempOrder.drinkVariation = firstSection[indexPath.row]
    case 1:
      if let previousIndexPath = indexPathOfPreviouslySelectedSection2 {
        tableView.deselectRow(at: previousIndexPath, animated: false)
        }
      indexPathOfPreviouslySelectedSection2 = indexPath
      TempOrder.drinkIceLevel = secondSection[indexPath.row]
    case 2:
      if let previousIndexPath = indexPathOfPreviouslySelectedSection3 {
        tableView.deselectRow(at: previousIndexPath, animated: false)
        }
      indexPathOfPreviouslySelectedSection3 = indexPath
      TempOrder.drinkSweetLevel = thirdSection[indexPath.row]
    case 3:
      if indexPath.row == 0 {
        if TempOrder.addWhitePearl == false {
          TempOrder.addWhitePearl = true
        } else {
          TempOrder.addWhitePearl = false
        }
      } else {
        if TempOrder.addWaterPearl == false {
          TempOrder.addWaterPearl = true
        } else {
          TempOrder.addWaterPearl = false
        }
      }
    default: break
    }

  }

}

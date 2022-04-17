//
//  ListViewController.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/16.
//

import UIKit

private let reuseIdentifier = "ListDetailCell"

class ListViewController: UIViewController {

  //MARK: - Properties
  private let topHeaderView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "background_dark")
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    return iv
  }()
  private let titleinHeaderLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
    label.text = "Group Orders"
    label.textColor = .white
    label.numberOfLines = 0
    return label
  }()
  private let dismissButton = ShadowsImageButton(systemName: "xmark.circle.fill", pointSize: 25, weight: .bold, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
//  private var groupDetail: [[String : String]] = []
  private var groupDetail: [Records] = []
  private var groupTotalPrice: Array<String>?
  private lazy var tableView: UITableView = {
    let tf = UITableView(frame: .zero, style: .plain)
    tf.register(ListForGroupTableViewCell.self, forCellReuseIdentifier: "ListDetailCell")
    tf.delegate = self
    tf.dataSource = self
    return tf
  }()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
    label.text = "\(Customer.group)"
    label.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    label.numberOfLines = 0
    return label
  }()
  private lazy var titlePrice: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    label.text = "$ 100"
    label.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    label.numberOfLines = 0
    return label
  }()

  private var myCell: IndexPath?
  //MARK: - Lifecycle
  override func viewWillAppear(_ animated: Bool) {
//    APIService.shared.getDataFromGroup { result, error  in
//      if let e = error {
//        print("DEBUG: Error getting Group Data from API: \(e.localizedDescription)")
//        self.showAlert(title: "Error getting Group Data from API: \(e.localizedDescription)")
//        return
//      }
//      print("DEBUG: result from API: \(result)")
//      self.groupDetail = result
//
//      DispatchQueue.main.async {
//        self.tableView.reloadData()
//      }
//    }
    APIService.shared.getDataByGroupFromAir { data in
      self.groupDetail = data
      print("DEBUG: ListViewController getDataByGroupFromAir \(data)")

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  //MARK: - Actions
  @objc func handleClose() {
    MainViewController.isPopedUp = true
    self.dismiss(animated: true)
  }


  //MARK: - Helpers
  fileprivate func configureUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black

    view.addSubview(topHeaderView)
    topHeaderView.anchor(top: view.topAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor)
    topHeaderView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    topHeaderView.addSubview(titleinHeaderLabel)
    titleinHeaderLabel.anchor(bottom: topHeaderView.bottomAnchor,
                              right: topHeaderView.rightAnchor,
                              paddingBottom: 5, paddingRight: 20)

    view.addSubview(tableView)
    tableView.anchor(top: topHeaderView.bottomAnchor,
                     left: view.leftAnchor,
                     bottom: view.bottomAnchor,
                     right: view.rightAnchor)
    tableView.backgroundColor = UIColor.white
    tableView.allowsSelection = false

    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         paddingTop: 20, paddingLeft: 20)
    dismissButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)

  }

  fileprivate func computeTotalPrice() -> Int {
    var result: Int = 0
    groupDetail.forEach({
      result += Int($0.fields.totalPrice)
    })
    return result
  }


}

  //MARK: - Extension: TableView Delegate & DataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if indexPath == myCell {
      let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] _, view, completeHandler in
        print("Delete your data")
        APIService.shared.deleteOrderInAir(id: groupDetail[indexPath.row].id!) { error in
          if let e = error {
            print("DEBUG: Error deleting data \(e.localizedDescription)")
            self.showAlert(title: "Error deleting data: \(e.localizedDescription)")
            return
          }
          DispatchQueue.main.async {
            self.groupDetail.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
            OrderViewController.harOrderedInList = false
            APIService.shared.getDataByGroupFromAir { result in
              self.groupDetail = result
              DispatchQueue.main.async {
                print("DEBUG: Get data for trailingSwipeActionsConfigurationForRowAt: \(result)")
                self.tableView.reloadData()
              }
            }
          }

        }
        completeHandler(true)
      }
      let swipeConfig = UISwipeActionsConfiguration(actions: [delete])
      swipeConfig.performsFirstActionWithFullSwipe = false
      return swipeConfig
    } else {
      return nil
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "\(Customer.group)"
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    40
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let titleView = UIView()
    titleView.backgroundColor = .white
    titleView.addSubview(titleLabel)
    titleLabel.anchor(left: titleView.leftAnchor,
                      bottom: titleView.bottomAnchor,
                      paddingLeft: 20, paddingBottom: 5)
    titleView.addSubview(titlePrice)
    titlePrice.text = "$ \(computeTotalPrice())"
    titlePrice.anchor(bottom: titleView.bottomAnchor,
                      right: titleView.rightAnchor,
                      paddingBottom: 5, paddingRight: 20)
    return titleView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    groupDetail.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ListForGroupTableViewCell
    let target = groupDetail[indexPath.row]
    cell.drinkNameLabel.text = "\(target.fields.name)\(target.fields.drink)x\(target.fields.number)"
    cell.drinkPrice.text = "$ \(target.fields.totalPrice)"
    cell.drinkImage.image = UIImage(named: "\(target.fields.drink)cup") ?? #imageLiteral(resourceName: "胭脂多多cup")
    if target.fields.addWhitePearl == true && target.fields.addWaterPearl == true {
      cell.infoLable.text = "\(target.fields.cupSize),\(target.fields.iceLevel),\(target.fields.sweetLevel),白玉珍珠+水玉"
    } else if target.fields.addWhitePearl != true && target.fields.addWaterPearl == true {
      cell.infoLable.text = "\(target.fields.cupSize),\(target.fields.iceLevel),\(target.fields.sweetLevel),水玉"
    } else if target.fields.addWhitePearl == true && target.fields.addWaterPearl != true {
      cell.infoLable.text = "\(target.fields.cupSize),\(target.fields.iceLevel),\(target.fields.sweetLevel),白玉珍珠"
    } else {
      cell.infoLable.text = "\(target.fields.cupSize),\(target.fields.iceLevel),\(target.fields.sweetLevel)"
    }
    if target.fields.name == Customer.name {
      cell.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
      cell.drinkNameLabel.textColor = .white
      cell.drinkPrice.textColor = .white
      cell.infoLable.textColor = .lightGray
      myCell = indexPath
    }
    return cell
  }

}


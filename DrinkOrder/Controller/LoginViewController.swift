//
//  LoginViewController.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/13.
//

import UIKit

class LoginViewController: UIViewController {

  //MARK: - Properties
  private let bottomView = UIView() 
  private let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "logo").withRenderingMode(.alwaysOriginal)
    iv.contentMode = .scaleAspectFit
    return iv
  }()

  private let userNameTextField = CustomizeTextField(placeholder: "Input User Name")
  private let groupTextField = CustomizeTextField(placeholder: "Input Group")
  private let loginButton = LoginButton(title: "Log In", type: .system)

  private var groups: Array<String>?
  private var newGroups: Array<String>?

  private lazy var pickerView = UIPickerView()
  private lazy var goToNewGroupButton: UIButton = {
    let button = UIButton(type: .system)
    let attributedTitle = NSMutableAttributedString(string: "Cant find your Group?  ", attributes: [
      .foregroundColor: UIColor.black,
      .font: UIFont.boldSystemFont(ofSize: 16)
    ])
    attributedTitle.append(NSAttributedString(string: "Create one.", attributes: [
      .foregroundColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1),
      .font: UIFont.boldSystemFont(ofSize: 16)
      ]))
    button.setAttributedTitle(attributedTitle, for: .normal)
    button.addTarget(self, action: #selector(handleAddGroup), for: .touchUpInside)
    return button
  }()
  //MARK: - Lifecycle
  override func viewWillAppear(_ animated: Bool) {
//    APIService.shared.getGroups { data in
//      self.groups = data
//      self.newGroups = self.groups?.uniqued()
//      print("DEBUG: newGroups \(self.newGroups!)")
//      DispatchQueue.main.async {
//        self.pickerView.reloadAllComponents()
//      }
//    }

    APIService.shared.getListOfGroupsFromAir(completion: { data in
      self.newGroups = data.uniqued()
      print("DEBUG: groups \(self.newGroups!)")
      DispatchQueue.main.async {
        self.pickerView.reloadAllComponents()
      }
    })

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  //MARK: - Actions
  @objc func handleAddGroup() {
    print("DEBUG: Add New Group")
    navigationController?.pushViewController(NewGroupViewController(), animated: true)
  }

  @objc func handleLogIn() {
    print("DEBUG: Log In")
    if userNameTextField.text == "" {
      self.showAlert(title: "Input User Name")
      return
    } else {
      Customer.name = userNameTextField.text!
    }
    if groupTextField.text == "" {
      self.showAlert(title: "Input Group")
      return
    } else {
      Customer.group = groupTextField.text!
    }
//    APIService.shared.getDataFromGroup { data, error in
//      if data.count > 0 {
//        for i in 0...data.count - 1 {
//          print("DEBUG: name in data: \(data[i]["name"]!)")
//          if data[i]["name"] == Customer.name {
//            OrderViewController.harOrderedInList = true
//          }
//        }
//        print("DEBUG: had already ordered is \(OrderViewController.harOrderedInList)")
//      }
//    }
    APIService.shared.getDataByGroupFromAir { data in
      if data.count > 0 {
        for i in 0...data.count - 1 {
          print("DEBUG: name in data: \(data[i].fields.name)")
          if data[i].fields.name == Customer.name {
            OrderViewController.harOrderedInList = true
          }
        }
        print("DEBUG: had already ordered is \(OrderViewController.harOrderedInList)")
      }
    }
    navigationController?.pushViewController(MainViewController(), animated: true)
  }

  //MARK: - Helpers
  private func configureUI() {
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barStyle = .black
    
    view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    view.addSubview(logoImageView)
    logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20)
    logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    view.addSubview(bottomView)
    bottomView.frame = CGRect(x: 0,
                              y: view.frame.maxY - view.frame.height * 0.7,
                              width: view.frame.width,
                              height: view.frame.height * 0.7)
    bottomView.backgroundColor = .white
    bottomView.addTopRoundedCornerToView(desiredCurve: 0.8)

    userNameTextField.autocorrectionType = .no
    groupTextField.delegate = self
    let stack = UIStackView(arrangedSubviews: [userNameTextField, groupTextField, loginButton])
    stack.spacing = 15
    stack.axis = .vertical
    bottomView.addSubview(stack)
    stack.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 32, paddingRight: 32)
    loginButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)

    bottomView.addSubview(pickerView)
    pickerView.anchor(left: bottomView.leftAnchor,
                      bottom: bottomView.bottomAnchor,
                      right: bottomView.rightAnchor,
                      paddingLeft: 10, paddingBottom: 5, paddingRight: 10)
    pickerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.isHidden = true

    bottomView.addSubview(goToNewGroupButton)
    goToNewGroupButton.anchor(left: bottomView.leftAnchor,
                              bottom: bottomView.bottomAnchor,
                              right: bottomView.rightAnchor,
                              paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    
  }

}
//MARK: - Extension UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.pickerView.isHidden = false
    self.goToNewGroupButton.isHidden = true
    return false
  }
}

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }


  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return newGroups?.count ?? 0
  }

  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let text = NSAttributedString(string: "\(newGroups?[row] ?? "")", attributes: [
      .foregroundColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)])
    return text
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.pickerView.isHidden = true
    self.goToNewGroupButton.isHidden = false
    self.groupTextField.text = newGroups![row]
  }

  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 50
  }


}

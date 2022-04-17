//
//  NewGroupViewController.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/15.
//

import UIKit

class NewGroupViewController: UIViewController {

  //MARK: - Properties
  private lazy var goBackButton: UIButton = {
    let button = UIButton()
    button.setTitle("Back", for: .normal)
    button.tintColor = .white
    button.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
    return button
  }()

  private let logoImageView: UIImageView = {
    let iv = UIImageView()
    iv.image = #imageLiteral(resourceName: "logo").withRenderingMode(.alwaysOriginal)
    iv.contentMode = .scaleAspectFit
    return iv
  }()

  private let userNameTextField = CustomizeTextField(placeholder: "Input User Name")
  private let groupTextField = CustomizeTextField(placeholder: "Input Group")
  private let bottomView = UIView()
  private let loginButton = LoginButton(title: "Create a New Group and log In", type: .system)


  //MARK: - Lifecyle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  //MARK: - Actions
  @objc func handleGoBack() {
    print("DEBUG: GO BACK")
    navigationController?.popViewController(animated: true)
  }

  @objc func handleLogIn() {
      print("DEBUG: Create New Group and Log In")
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
//      APIService.shared.getDataFromGroup { data, error in
//        if data.count > 0 {
//          for i in 0...data.count - 1 {
//            print("DEBUG: name in data: \(data[i]["name"]!)")
//            if data[i]["name"] == Customer.name {
//              OrderViewController.harOrderedInList = true
//            }
//          }
//        } else {
//          print("DEBUG: data: \(data)")
//          OrderViewController.harOrderedInList = false
//        }
//        print("DEBUG: had already ordered is \(OrderViewController.harOrderedInList)")
//      }
      APIService.shared.getDataByGroupFromAir { data in
        if data.count > 0 {
          for i in 0...data.count - 1 {
            print("DEBUG: name in data: \(data[i].fields.name)")
            if data[i].fields.name == Customer.name {
              OrderViewController.harOrderedInList = true
            }
          }
          print("DEBUG: had already ordered is \(OrderViewController.harOrderedInList)")
        } else {
          print("DEBUG: data: \(data)")
          OrderViewController.harOrderedInList = false
        }
      }
      navigationController?.pushViewController(MainViewController(), animated: true)
  }

  //MARK: - Helpers
  fileprivate func configureUI() {

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
    groupTextField.autocorrectionType = .no
    let stack = UIStackView(arrangedSubviews: [userNameTextField, groupTextField, loginButton])
    stack.spacing = 15
    stack.axis = .vertical
    bottomView.addSubview(stack)
    stack.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, right: view.rightAnchor, paddingTop: 120, paddingLeft: 32, paddingRight: 32)
    loginButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
    loginButton.backgroundColor = UIColor(named: "DeepYellowColor") ?? #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
    view.addSubview(goBackButton)
    goBackButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 50, paddingRight: 20)
    
  }


}

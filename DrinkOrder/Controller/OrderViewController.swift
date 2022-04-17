//
//  OrderViewController.swift
//  DrinkOrder
//
//  Created by Min-Yang Huang on 2022/4/9.
//

import UIKit

class OrderViewController: UIViewController {

  //MARK: - Properties
  var items = [Item]()
  private let doneButton = SendOrderButton()
  private let showView = ViewOrderView()
  private let noteTextField : UITextField = {
    let tf = UITextField()
    let spacer = UIView()
    spacer.setDimensions(height: 50, width: 12)
    tf.leftView = spacer
    tf.leftViewMode = .always
    tf.borderStyle = .none
    tf.backgroundColor = .white
    tf.heightAnchor.constraint(equalToConstant: 100).isActive = true
    tf.textColor = .black
    tf.attributedPlaceholder = NSAttributedString(string: "備註Note(Optional)", attributes: [
      .foregroundColor: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1).withAlphaComponent(0.7)
    ])
    tf.layer.cornerRadius = 10
    return tf
  }()
  static var harOrderedInList = false

  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    configureGradientLayer()
    configureUI()

  }

  //MARK: - Actions
  @objc func handleEdit() {
    dismiss(animated: true)
  }

  @objc func handleCancel() {
    print("DEBUG: Cancel Order.")
    TempOrder.clearOrder()
    self.presentingViewController?.presentingViewController?.dismiss(animated: true)
  }

  @objc func handleSaveDrink() {
    if OrderViewController.harOrderedInList == false {
      print("DEBUG: ADD New Order.")
      TempOrder.note = noteTextField.text ?? ""
      print("DEBUG: You write a note: \(TempOrder.note)")
      APIService.shared.postOrderToAir {
        OrderViewController.harOrderedInList = true
        TempOrder.clearOrder()
      }
      self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    } else {
      self.showAlert(title: "You had already ordered.")
      return
    }

  }

  //MARK: - Helpers
  fileprivate func configureUI() {

    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.prefersLargeTitles = true

    navigationController?.navigationBar.tintColor = UIColor(named: "DeepBlueColor")
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    navigationItem.title = "Your Order"
    navigationController?.navigationBar.tintColor = UIColor.white
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    navigationController?.navigationBar.largeTitleTextAttributes = textAttributes

    view.addSubview(showView)
    view.addSubview(doneButton)
    doneButton.anchor(left: view.leftAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      right: view.rightAnchor,
                      paddingLeft: 30,
                      paddingBottom: 10,
                      paddingRight: 30)
    doneButton.addTarget(self, action: #selector(handleSaveDrink), for: .touchUpInside)
    showView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                    left: view.leftAnchor,
                    right: view.rightAnchor,
                    paddingTop: 20,
                    paddingLeft: 20,
                    paddingRight: 20)
    showView.heightAnchor.constraint(equalToConstant: 120).isActive = true

    view.addSubview(noteTextField)
    noteTextField.anchor(top: showView.bottomAnchor,
                         left: view.leftAnchor,
                         right: view.rightAnchor,
                         paddingTop: 20, paddingLeft: 20, paddingRight: 20)

  }

}

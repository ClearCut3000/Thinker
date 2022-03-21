//
//  SignUpViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class SignUpViewController: UITabBarController {

  //MARK: - Properties
  private let headerView = SignInHeaderView()

  private let nameField:  UITextField = {
    let field = UITextField()
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    field.leftViewMode = .always
    field.autocorrectionType = .no
    field.placeholder = "Full name"
    field.backgroundColor = .secondarySystemBackground
    field.layer.cornerRadius = 8
    field.layer.masksToBounds = true
    return field
  }()

  private let emailField:  UITextField = {
    let field = UITextField()
    field.keyboardType = .emailAddress
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    field.leftViewMode = .always
    field.placeholder = "E-mail address"
    field.backgroundColor = .secondarySystemBackground
    field.layer.cornerRadius = 8
    field.layer.masksToBounds = true
    return field
  }()

  private let passwordField:  UITextField = {
    let field = UITextField()
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    field.leftViewMode = .always
    field.placeholder = "Password field"
    field.isSecureTextEntry = true
    field.backgroundColor = .secondarySystemBackground
    field.layer.cornerRadius = 8
    field.layer.masksToBounds = true
    return field
  }()

  private let signUpButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemGreen
    button.setTitle("Create Account", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    return button
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Create Account"
    view.backgroundColor = .systemBackground
    view.addSubview(headerView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(signUpButton)
    view.addSubview(nameField)
    signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)
    nameField.frame = CGRect(x: 20, y: headerView.bottom+10, width: view.width-40, height: 50)
    emailField.frame = CGRect(x: 20, y: nameField.bottom+10, width: view.width-40, height: 50)
    passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
    signUpButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50)
  }

  //MARK: - Methods
  @objc func didTapSignUp() {
    guard let email = emailField.text, !email.isEmpty,
          let password = passwordField.text, !password.isEmpty,
          let name = nameField.text, !name.isEmpty else { return }
    HapticsManager.shared.vibrateForSelection()
    AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
      if success {
        let newUser = User(name: name, email: email, profilePictureRef: nil)
        DatabaseManager.shared.insert(user: newUser) { inserted in
          guard inserted else { return }
          UserDefaults.standard.set(email, forKey: "email")
          UserDefaults.standard.set(name, forKey: "name")
          DispatchQueue.main.async {
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
          }
        }
      } else {
        print("Failed to create account")
      }
    }
  }

}

//
//  SignInViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class SignInViewController: UITabBarController {

  //MARK: - Properties
  private let headerView = SignInHeaderView()

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
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    field.leftViewMode = .always
    field.placeholder = "Password field"
    field.autocapitalizationType = .none
    field.autocorrectionType = .no
    field.isSecureTextEntry = true
    field.backgroundColor = .secondarySystemBackground
    field.layer.cornerRadius = 8
    field.layer.masksToBounds = true
    return field
  }()

  private let signInButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.setTitle("Sign In", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    return button
  }()

  private let createAccountButton: UIButton = {
    let button = UIButton()
    button.setTitle("Create Account", for: .normal)
    button.setTitleColor(.link, for: .normal)
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    return button
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Sign In"
    view.backgroundColor = .systemBackground
    view.addSubview(headerView)
    view.addSubview(emailField)
    view.addSubview(passwordField)
    view.addSubview(signInButton)
    view.addSubview(createAccountButton)
    signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)
    emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
    passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 50)
    signInButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 50)
    createAccountButton.frame = CGRect(x: 20, y: signInButton.bottom+40, width: view.width-40, height: 50)
  }

  //MARK: - Methods

  @objc func didTapSignIn() {
    guard let email = emailField.text, !email.isEmpty,
          let password = passwordField.text, !password.isEmpty else { return }
    AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
      guard success else { return }
      IAPManager.shared.getSubscriptionsStatus(completion: nil)
      DispatchQueue.main.async {
        UserDefaults.standard.set(email, forKey: "email")
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self?.present(vc, animated: true)
      }
    }
  }

  @objc func didTapCreateAccount() {
    let vc = SignUpViewController()
    vc.title = "Create Account"
    vc.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(vc, animated: true)
  }
}

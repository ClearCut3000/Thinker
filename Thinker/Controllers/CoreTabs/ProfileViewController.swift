//
//  ProfileViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .systemBackground
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(didTapSignOut))
    }

  @objc private func didTapSignOut() {
    let alert = UIAlertController(title: "Sign Out!", message: "Are you shure you'd like to sign out?", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
      AuthManager.shared.signOut { [weak self] success in
        if success {
          DispatchQueue.main.async {
            UserDefaults.standard.set(nil, forKey: "email")
            UserDefaults.standard.set(nil, forKey: "name")
            let signInVC = SignInViewController()
            signInVC.navigationItem.largeTitleDisplayMode = .always
            let navVC = UINavigationController(rootViewController: signInVC)
            navVC.navigationBar.prefersLargeTitles = true
            navVC.modalPresentationStyle = .fullScreen
            self?.present(navVC, animated: true)
          }
        }
      }
    }))
    present(alert, animated: true)
  }
}

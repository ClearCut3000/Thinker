//
//  SignInViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class SignInViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Sign In"
    view.backgroundColor = .systemBackground

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      if !IAPManager.shared.isPremium() {
        let viewController = PayWallViewController()
        let navViewController = UINavigationController(rootViewController: viewController)
        self.present(viewController, animated: true)
      }
    }
  }
}

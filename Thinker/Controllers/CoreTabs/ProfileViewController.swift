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

  }
}

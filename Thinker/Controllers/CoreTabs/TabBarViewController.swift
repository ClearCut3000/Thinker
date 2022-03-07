//
//  TabBarViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class TabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpControllers()
  }

  //MARK: - Methods
  private func setUpControllers() {
    let home = HomeViewController()
    home.title = "Home"
    let profile = ProfileViewController()
    profile.title = "Profile"
    home.navigationItem.largeTitleDisplayMode = .always
    profile.navigationItem.largeTitleDisplayMode = .always
    let HomeNavigationController = UINavigationController(rootViewController: home)
    let ProfileNavigationController = UINavigationController(rootViewController: profile)
    HomeNavigationController.navigationBar.prefersLargeTitles = true
    ProfileNavigationController.navigationBar.prefersLargeTitles = true
    HomeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
    ProfileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
    setViewControllers([HomeNavigationController, ProfileNavigationController], animated: true)
  }
}

//
//  HomeViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class HomeViewController: UIViewController {

  //MARK: - Properties
  private let composeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.tintColor = .white
    button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
    button.layer.cornerRadius = 30
    button.layer.shadowColor = UIColor.label.cgColor
    button.layer.shadowOpacity = 0.4
    button.layer.shadowRadius = 10
    return button
  }()

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    view.addSubview(composeButton)
    composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    composeButton.frame = CGRect(x: view.frame.width - 88,
                                 y: view.frame.height - 88 - view.safeAreaInsets.bottom,
                                 width: 60,
                                 height: 60)

  }

  //MARK: - Methods
  @objc private func didTapCreate() {
    let vc = CreateNewPostViewController()
    vc.title = "Create Post"
    let navVC = UINavigationController(rootViewController: vc)
    present(navVC, animated: true)
  }

}

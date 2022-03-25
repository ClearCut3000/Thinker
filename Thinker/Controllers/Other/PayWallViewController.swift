//
//  PayWallViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 09.03.2022.
//

import UIKit

class PayWallViewController: UIViewController {

  //MARK: - Properties
  private let header = PayWallHeaderView()

  private let heroView = PayWallDescriptionView()

  private let buyButton: UIButton = {
    let button = UIButton()
    button.setTitle("Subscribe", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    return button
  }()

  private let restoreButton: UIButton = {
    let button = UIButton()
    button.setTitle("Restore Purchases", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    return button
  }()

  private let termsView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.textAlignment = .center
    textView.textColor = .secondaryLabel
    textView.font = .systemFont(ofSize: 14)
    textView.text = "This is auto-renewable subscription. It will be changed to your iTunes account before each pay period. You can cancel it anytime by going into your Settings -> Subscriptions. Restore purchases if previously subscribed."
    return textView
  }()

  //MARK - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Thinker Premium"
    view.backgroundColor = .systemBackground
    view.addSubview(header)
    view.addSubview(buyButton)
    view.addSubview(restoreButton)
    view.addSubview(termsView)
    view.addSubview(heroView)
    setUpCloseButton()
    setUpButtons()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    header.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 3.2)
    termsView.frame = CGRect(x: 10, y: view.height - 100, width: view.width - 20, height: 100)
    restoreButton.frame = CGRect(x: 25, y: termsView.top - 70, width: view.width - 50, height: 50)
    buyButton.frame = CGRect(x: 25, y: restoreButton.top - 60 , width: view.width - 50, height: 50)
    heroView.frame = CGRect(x: 0, y: header.bottom, width: view.width, height: buyButton.top - view.safeAreaInsets.top - header.height)
  }

  //MARK: - UIMethods
  private func setUpButtons() {
    buyButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
    restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
  }

  @objc private func didTapSubscribe() {
    IAPManager.shared.fetchPackages { package in
      guard let package = package else { return }
      IAPManager.shared.subscribe(package: package) { [weak self] success in
        DispatchQueue.main.async {
          if success {
            self?.dismiss(animated: true, completion: nil)
          } else {
            let alert = UIAlertController(title: "Subscription failed!", message: "We are anable to complete transaction.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            self?.present(alert, animated: true)
          }
        }
      }
    }
  }

  @objc private func didTapRestore() {
    IAPManager.shared.restorePurchases { [weak self] success in
      DispatchQueue.main.async {
        if success {
          self?.dismiss(animated: true, completion: nil)
        } else {
          let alert = UIAlertController(title: "Restoration failed!", message: "We are anable to restore previous ransaction.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
          self?.present(alert, animated: true)
        }
      }
    }
  }

  private func setUpCloseButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
  }

  @objc private func didTapClose() {
    dismiss(animated: true, completion: nil)
  }


}

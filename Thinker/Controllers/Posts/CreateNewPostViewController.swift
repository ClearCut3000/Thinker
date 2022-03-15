//
//  CreateNewPostViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class CreateNewPostViewController: UITabBarController {

  //MARK: - Properties
  private let headerImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.isUserInteractionEnabled = true
    imageView.image = UIImage(systemName: "photo")
    imageView.backgroundColor = .tertiarySystemBackground
    return imageView
  }()

  private let titleField:  UITextField = {
    let field = UITextField()
    field.autocapitalizationType = .words
    field.autocorrectionType = .yes
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
    field.leftViewMode = .always
    field.placeholder = "Enter Title..."
    field.backgroundColor = .secondarySystemBackground
    field.layer.masksToBounds = true
    return field
  }()

  private let textView: UITextView = {
    let textView = UITextView()
    textView.backgroundColor = .tertiarySystemBackground
    textView.isEditable = true
    textView.font = .systemFont(ofSize: 28)
    return textView
  }()

  private var selectedHeaderImage: UIImage?

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    view.addSubview(headerImageView)
    view.addSubview(titleField)
    view.addSubview(textView)
    configureButtons()
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width-20, height: 50)
    headerImageView.frame = CGRect(x: 0, y: titleField.bottom+5, width: view.width, height: 160)
    textView.frame = CGRect(x: 10, y: headerImageView.bottom+10, width: view.width-20, height: view.height-210-view.safeAreaInsets.top)
  }

  //MARK: - Methods
  private func configureButtons() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
  }

  @objc private func didTapCancel() {

  }

  @objc private func didTapPost() {
    guard let title = titleField.text,
          let body = textView.text,
          let headerImage = selectedHeaderImage,
          !title.trimmingCharacters(in: .whitespaces).isEmpty,
          !body.trimmingCharacters(in: .whitespaces).isEmpty else { return }
    let post = BlogPost(identifier: UUID().uuidString , title: title, timeStamp: Date().timeIntervalSince1970, headerImageUrl: nil, text: body)
    
  }
}

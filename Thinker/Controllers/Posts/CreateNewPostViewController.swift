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
    imageView.clipsToBounds = true
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
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
    headerImageView.addGestureRecognizer(tap)
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
  @objc private func didTapHeader() {
    let picker = UIImagePickerController()
    picker.delegate = self
    let alert = UIAlertController(title: "Choose image source, please.", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
      }))
    }
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
        picker.sourceType = .camera
        self.present(picker, animated: true)
      }))
    }
    present(alert, animated: true)
  }

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
          let email = UserDefaults.standard.string(forKey: "email"),
          !title.trimmingCharacters(in: .whitespaces).isEmpty,
          !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            let alert = UIAlertController(title: "Enter post details.", message: "Please enter tile, body and select an image to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
          }
    let newPostId = UUID().uuidString
    StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostId) { success in
      guard success else { return }
      StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
        guard let headerUrl = url else {
          DispatchQueue.main.async {
            HapticsManager.shared.vibrate(for: .error)
          }
          return
        }
        let post = BlogPost(identifier: newPostId , title: title, timeStamp: Date().timeIntervalSince1970, headerImageUrl: headerUrl, text: body)
        DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in
          guard posted else {
            DispatchQueue.main.async {
              HapticsManager.shared.vibrate(for: .error)
            }
            return
          }
          DispatchQueue.main.async {
            HapticsManager.shared.vibrate(for: .success)
            self?.didTapCancel()
          }
        }
      }
    }
  }
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.originalImage] as? UIImage else { return }
    selectedHeaderImage = image
    headerImageView.image = image
  }
}

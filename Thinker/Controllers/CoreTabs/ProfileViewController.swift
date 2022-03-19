//
//  ProfileViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //MARK: - Properties
  private var user: User?

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier )
    return tableView
  }()

  let currentEmail: String

  private var posts: [BlogPost] = []

  //MARK: - Init's
  init(currentEmail: String) {
    self.currentEmail = currentEmail
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setUpSignUpButton()
    setUpTable()
    title = "Profile"
    fetchPosts()
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }

  //MARK: - Methods
  private func setUpTable() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    setUpTableHeader()
    fetchProfileData()
  }

  private func  fetchProfileData() {
    DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
      guard let user = user else { return }
      self?.user = user
      DispatchQueue.main.async {
        self?.setUpTableHeader(profilePhotoRef: user.profilePictureRef, name: user.name)
      }
    }
  }

  private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
    headerView.backgroundColor = .systemBlue
    headerView.isUserInteractionEnabled = true

    headerView.clipsToBounds = true
    tableView.tableHeaderView = headerView
    let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
    profilePhoto.tintColor = .white
    profilePhoto.contentMode = .scaleAspectFit
    profilePhoto.frame = CGRect(x: (view.width - (view.width/4))/2, y: (headerView.height-(view.width/4))/2.5, width: view.width/4, height: view.width/4)
    profilePhoto.layer.masksToBounds = true
    profilePhoto.layer.cornerRadius = profilePhoto.width / 2
    profilePhoto.isUserInteractionEnabled = true
    headerView.addSubview(profilePhoto)
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
    profilePhoto.addGestureRecognizer(tap)
    let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom+10, width: view.width-40, height: 100))
    headerView.addSubview(emailLabel)
    emailLabel.text = currentEmail
    emailLabel.textAlignment = .center
    emailLabel.textColor = .white
    emailLabel.font = .systemFont(ofSize: 24, weight: .bold)
    if let name = name {
      title = name
    }
    if let ref = profilePhotoRef {
      StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
          guard let data = data else { return }
          DispatchQueue.main.async {
            profilePhoto.image = UIImage(data: data)
          }
        }
        task.resume()
      }
    }
  }

  @objc private func didTapProfilePhoto() {
    guard let myEmail = UserDefaults.standard.string(forKey: "email"), myEmail == currentEmail else { return }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    let alert = UIAlertController(title: "Please, choose image source!", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
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

  private func setUpSignUpButton() {
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

  private func fetchPosts() {
    DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
      self?.posts = posts
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }

  //MARK: - TableView Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let post = posts[indexPath.row]
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else { fatalError() }
    cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let vc = ViewPostViewController(post: posts[indexPath.row])
    vc.navigationItem.largeTitleDisplayMode = .never
    vc.title = "Post"
    navigationController?.pushViewController(vc, animated: true)
  }
}

//MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)
    guard let image = info[.editedImage] as? UIImage else { return }
    StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) { [weak self] success in
      guard let strongSelf = self else { return }
      if success {
        DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
          guard updated else { return }
          DispatchQueue.main.async {
            strongSelf.fetchProfileData()
          }
        }
      }
    }
  }
}

//
//  HomeViewController.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier )
    return tableView
  }()

  private var posts: [BlogPost] = []

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
    view.addSubview(tableView)
    view.addSubview(composeButton)
    composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
    tableView.delegate = self
    tableView.dataSource = self
    fetchAllPosts()
  }

  //MARK: - Layout
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    composeButton.frame = CGRect(x: view.frame.width - 88,
                                 y: view.frame.height - 88 - view.safeAreaInsets.bottom,
                                 width: 60,
                                 height: 60)
    tableView.frame = view.bounds

  }

  //MARK: - Methods
  @objc private func didTapCreate() {
    let vc = CreateNewPostViewController()
    vc.title = "Create Post"
    let navVC = UINavigationController(rootViewController: vc)
    present(navVC, animated: true)
  }

  private func fetchAllPosts() {
    DatabaseManager.shared.getAllPosts { [weak self] posts in
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
    HapticsManager.shared.vibrateForSelection()
    guard IAPManager.shared.canViewPost else {
      let vc = PayWallViewController()
      present(vc, animated: true)
      return
    }
    let vc = ViewPostViewController(post: posts[indexPath.row])
    vc.navigationItem.largeTitleDisplayMode = .never
    vc.title = "Post"
    navigationController?.pushViewController(vc, animated: true)
  }

}

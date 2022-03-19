//
//  PostHeaderTableViewCell.swift
//  Thinker
//
//  Created by Николай Никитин on 17.03.2022.
//

import UIKit

class PostHeaderTableViewCell: UITableViewCell {

static let identifier = "PostHeaderTableViewCell"

  //MARK: - Properties
  private let postImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  //MARK: - init's
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.clipsToBounds = true
    contentView.addSubview(postImageView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    postImageView.frame = contentView.bounds
  }

  //MARK: - Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    postImageView.image = nil
  }

  func configure(with viewModel: PostHeaderTableViewCellViewModel) {
    if let data = viewModel.imageData {
      postImageView.image = UIImage(data: data)
    } else if let url = viewModel.imageUrl {
      let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
        guard let data = data else { return }
        viewModel.imageData = data
        DispatchQueue.main.async {
          self?.postImageView.image = UIImage(data: data)
        }
      }
      task.resume()
    }
  }

}

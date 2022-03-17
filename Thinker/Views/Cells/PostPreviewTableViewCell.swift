//
//  PostPreviewTableViewCell.swift
//  Thinker
//
//  Created by Николай Никитин on 17.03.2022.
//

import UIKit

class PostPreviewTableViewCell: UITableViewCell {

  //MARK: - Properties
  static let identifier = "PostPreviewTableViewCell"

  private let postImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let postTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 20, weight: .medium)
    return label
  }()

  //MARK: - init's
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.clipsToBounds = true
    contentView.addSubview(postTitleLabel)
    contentView.addSubview(postImageView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Layout
  override func layoutSubviews() {
    super.layoutSubviews()
    postImageView.frame = CGRect(x: separatorInset.left,
                                 y: 5,
                                 width: contentView.height-10,
                                 height: contentView.height-10)
    postTitleLabel.frame = CGRect(x: postImageView.right + 5,
                                  y: 5,
                                  width: contentView.width-5-separatorInset.left-postImageView.width ,
                                  height: contentView.height-10)
  }

  //MARK: - Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    postTitleLabel.text = nil
    postImageView.image = nil
  }

  func configure(with string: String) {

  }
}

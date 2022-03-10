//
//  PayWallDescriptionView.swift
//  Thinker
//
//  Created by Николай Никитин on 11.03.2022.
//

import UIKit

class PayWallDescriptionView: UIView {

  private let descriptorLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 26, weight: .medium)
    label.numberOfLines = 0
    label.text  = "Join Thinker premiun to read unlimited articles and browse thousands of posts!"
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 22, weight: .regular)
    label.numberOfLines = 1
    label.text = "$4.99 per month"
    return label
  }()


  override init(frame: CGRect) {
    super.init(frame: frame)
    clipsToBounds = true
    addSubview(descriptorLabel)
    addSubview(priceLabel)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    descriptorLabel.frame = CGRect(x: 20, y: 0, width: width - 40, height: height / 2)
    priceLabel.frame = CGRect(x: 20, y: height / 2, width: width - 40, height: height / 2)
  }
}

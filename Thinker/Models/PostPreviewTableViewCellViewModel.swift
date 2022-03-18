//
//  PostPreviewTableViewCellViewModel.swift
//  Thinker
//
//  Created by Николай Никитин on 17.03.2022.
//

import Foundation

class PostPreviewTableViewCellViewModel {
  let title: String
  let imageUrl: URL?
  var imageData: Data?

  init(title: String, imageUrl: URL?) {
    self.title = title
    self.imageUrl = imageUrl
  }
}

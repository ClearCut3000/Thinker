//
//  PostHeaderTableViewCellViewModel.swift
//  Thinker
//
//  Created by Николай Никитин on 19.03.2022.
//

import Foundation

class PostHeaderTableViewCellViewModel {

  let imageUrl: URL?
  var imageData: Data?

  init(imageUrl: URL?) {
    self.imageUrl = imageUrl
  }
}

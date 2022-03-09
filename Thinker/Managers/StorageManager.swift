//
//  StorageManager.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import Foundation
import FirebaseFirestore

final class StorageManager {

  //MARK: - Propeties
  static let shared = StorageManager()

  private init() {}

  static let database = Storage.storage()


}



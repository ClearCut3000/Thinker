//
//  DatabaseManager.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {

  //MARK: - Properties
  static let shared = DatabaseManager()

  private init() {}

  static let database = Firestore.firestore()

  //MARK: - Methods
  public func insertBlogPost() {
    
  }
}

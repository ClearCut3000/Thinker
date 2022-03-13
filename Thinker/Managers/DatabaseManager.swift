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

  private let database = Firestore.firestore()

  //MARK: - Methods
  public func insert(blogPost: BlogPost, user: User, completion: @escaping (Bool) -> Void) {

  }

  public func getAllPosts(completion: @escaping ([BlogPost]) -> Void) {

  }

  public func getPosts(for user: User, completion: @escaping ([BlogPost]) -> Void) {

  }

  public func insert(user: User, completion: @escaping (Bool) -> Void) {
    let documentId = user.email.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
    let data = [
      "email": user.email,
      "name": user.name
    ]
    database.collection("users")
            .document("documentId")
            .setData(data) { error in
              completion(error == nil)
            }
  }
}

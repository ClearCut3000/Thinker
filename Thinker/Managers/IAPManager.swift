//
//  IAPManager.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import Foundation
import Purchases

final class IAPManager {

  //MARK: - Properties
  static let shared = IAPManager()

  private init() {}

  //MARK: - Methods
  func isPremium() -> Bool {
    return false
  }

  func subscribe() {

  }

  func restorePurchases() {

  }


}

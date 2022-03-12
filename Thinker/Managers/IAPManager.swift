//
//  IAPManager.swift
//  Thinker
//
//  Created by Николай Никитин on 07.03.2022.
//

import Foundation
import Purchases
import StoreKit

final class IAPManager {

  //MARK: - Properties
  static let shared = IAPManager()

  private init() {}

  //MARK: - Methods
  public func getSubscriptionsStatus(completion: ((Bool) -> Void)?) {
    Purchases.shared.purchaserInfo { info, error in
      guard let entitlements = info?.entitlements, error == nil else { return }
      if entitlements.all["Premium"]?.isActive == true {
        UserDefaults.standard.set(true, forKey: "premium")
        completion?(true)
      } else {
        UserDefaults.standard.set(false, forKey: "premium")
        completion?(false)
      }
    }
  }

  func isPremium() -> Bool {
    return UserDefaults.standard.bool(forKey: "premium")
  }

  public func subscribe(package: Purchases.Package, completion: @escaping (Bool) -> Void) {
    guard !isPremium() else {
      completion(true)
      return
    }
    Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
      guard let transaction = transaction,
            let entitlements = info?.entitlements,
            error == nil,
            !userCancelled else {
              return
            }
      switch transaction.transactionState {
      case .purchasing:
        print("purchasing")
      case .purchased:
        if entitlements.all["Premium"]?.isActive == true {
          UserDefaults.standard.set(true, forKey: "premium")
          completion(true)
        } else {
          UserDefaults.standard.set(false, forKey: "premium")
          completion(false)
        }
        print("purchased: \(entitlements)")
        UserDefaults.standard.set(true, forKey: "premium")
      case .failed:
        print("failed")
      case .restored:
        print("restored")
      case .deferred:
        print("deferred")
      @unknown default:
        print("Default case")
      }
    }
  }

  public func restorePurchases(completion: @escaping (Bool) -> Void) {
    Purchases.shared.restoreTransactions { info, error in
      guard let entitlements = info?.entitlements, error == nil else { return }
      if entitlements.all["Premium"]?.isActive == true {
        UserDefaults.standard.set(true, forKey: "premium")
        completion(true)
      } else {
        UserDefaults.standard.set(false, forKey : "premium")
        completion(false)
      }
    }
  }

  public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
    Purchases.shared.offerings { offerings, error in
      guard let package = offerings?.offering(identifier: "default")?.availablePackages.first, error == nil else {
        completion(nil)
        return
      }
      completion(package)
    }
  }

}

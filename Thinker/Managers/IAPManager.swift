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

  static let formatter = ISO8601DateFormatter()

  private var postEligibleViewDate: Date? {
    get {
      guard let string = UserDefaults.standard.string(forKey: "postEligibleViewDate") else { return nil }
      return IAPManager.formatter.date(from: string)
    }
    set {
      guard let date = newValue else { return }
      let string = IAPManager.formatter.string(from: date)
      UserDefaults.standard.set(string, forKey: "postEligibleViewDate")
    }
  }

  private init() {}

  //MARK: - Methods
  public func getSubscriptionsStatus(completion: ((Bool) -> Void)?) {
    Purchases.shared.purchaserInfo { info, error in
      guard let entitlements = info?.entitlements, error == nil else { return }
      if entitlements.all["Premium"]?.isActive == true {
        print("Got updated status of subscribed")
        UserDefaults.standard.set(true, forKey: "premium")
        completion?(true)
      } else {
        print("Got updated status of NOT subscribed")
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

//MARK: - Track Post Views
extension IAPManager {
  var canViewPost: Bool {
    if isPremium() { return true }
    guard let date = postEligibleViewDate else {
      return true
    }
    UserDefaults.standard.set(0, forKey: "post_views")
    return Date() >= date
  }

  public func loadPostViewed() {
    let total = UserDefaults.standard.integer(forKey: "post_views")
    UserDefaults.standard.set(total + 1, forKey: "post_views")
    if total == 2 {
      let hour: TimeInterval = 60 * 60
      postEligibleViewDate = Date().addingTimeInterval(hour * 24)
    }
  }
}

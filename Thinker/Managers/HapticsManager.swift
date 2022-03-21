//
//  HapticsManager.swift
//  Thinker
//
//  Created by Николай Никитин on 21.03.2022.
//

import Foundation
import UIKit

class HapticsManager {

  //MARK: - Properties
  static let shared = HapticsManager()

  //MARK: - Init's
  private init() {}

  //MARK: - Methods
  func vibrateForSelection() {
    let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
  }

  func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(type)
  }
}

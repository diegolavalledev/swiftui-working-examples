#if os(iOS)

import Foundation
import UIKit
import CoreGraphics
import Combine

class KeyboardProperties: ObservableObject {
  
  static let shared = KeyboardProperties()
  
  @Published var frame = CGRect.zero

  var subscription: Cancellable?

  init() {
    subscription = NotificationCenter.default
    .publisher(for: UIResponder.keyboardDidShowNotification)
    .compactMap { $0.userInfo }
    .compactMap {
      $0[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
    .merge(
      with: NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification).map { _ in
        CGRect.zero
      }
    )
    .assign(to: \.frame, on: self)
  }
}

#endif

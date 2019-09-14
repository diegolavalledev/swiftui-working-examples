import Combine
import UIKit

class KeyboardProperties: ObservableObject {
  
  static let shared = KeyboardProperties()
  
  @Published var height: CGFloat = 0
  
  init() {
    
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: OperationQueue.main) { [weak self ] (notification) in
      self?.height = 0
    }
    
    let handler: (Notification) -> Void = { [weak self] notification in
      guard let userInfo = notification.userInfo else { return }
      guard let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
      
      // From Apple docs:
      // The rectangle contained in the UIKeyboardFrameBeginUserInfoKey and UIKeyboardFrameEndUserInfoKey properties of the userInfo dictionary should be used only for the size information it contains. Do not use the origin of the rectangle (which is always {0.0, 0.0}) in rectangle-intersection operations. Because the keyboard is animated into position, the actual bounding rectangle of the keyboard changes over time.
      
      self?.height = frame.size.height
    }
    
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: OperationQueue.main, using: handler)
    
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: OperationQueue.main, using: handler)
    
  }
}

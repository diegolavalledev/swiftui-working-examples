#if os(iOS)

import SwiftUI

struct FlyModifier: AnimatableModifier {

  var totalDistance: CGFloat
  var percentage: CGFloat
  var onReachedDestination: () -> () = {}

  private var distance: CGFloat { percentage * totalDistance }

  var animatableData: CGFloat {
    get { percentage }
    set {
      percentage = newValue
      checkIfFinished()
    }
  }

  func checkIfFinished() -> () {
    if percentage == 1 {
      DispatchQueue.main.async {
        self.onReachedDestination()
      }
    }
  }

  func body(content: Content) -> some View {
    content
    .offset(x: distance, y: -distance)
  }
}

struct FlyModifier_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Image(systemName: "paperplane")
      .foregroundColor(.red)
      Image(systemName: "paperplane")
      .foregroundColor(.green)
      .modifier(
        FlyModifier(totalDistance: 50, percentage: 1)
      )
    }
    .frame(width: 100, height: 100, alignment: .bottomLeading)
    .previewLayout(.sizeThatFits)
  }
}

#endif

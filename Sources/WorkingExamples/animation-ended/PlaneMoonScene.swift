import SwiftUI

public struct PlaneMoonScene: View {
  
  static let totalDistance: CGFloat = 200
  static let moonDistance: CGFloat = totalDistance + 30

  @State var distance: CGFloat = 0

  var reachedMoon: Bool {
    distance == Self.totalDistance
  }

  var isFlying: Bool {
    distance > 0 && !reachedMoon
  }

  var bluePlane: some View {
    Image(systemName: "paperplane.fill")
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 50)
    .foregroundColor(isFlying ? .red : .orange)
  }

  var moon: some View {
    Image(systemName: "moon.stars.fill")
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 80)
    .foregroundColor(.yellow)
    .rotationEffect(.degrees(15))
    .offset(x: Self.moonDistance, y: -Self.moonDistance)
  }

  var buttons: some View {
    Group {
      if reachedMoon {
        Button("Reset") {
          self.distance = 0
        }
      } else {
        Button("Launch!") {
          withAnimation(.easeInOut(duration: 1)) {
            self.distance = Self.totalDistance
          }
        }.disabled(isFlying)
      }
    }
    .padding()
  }

  public init() { }

  public var body: some View {
    VStack {
      ZStack(alignment: .bottomLeading) {
        Color.purple // Background
        moon
        bluePlane
        .offset(x: distance, y: -distance)
      }
      .padding()
      buttons
    }
  }
}

struct PlaneMoonScene_Previews: PreviewProvider {
  static var previews: some View {
    PlaneMoonScene()
  }
}

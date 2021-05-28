import SwiftUI

struct Moonshot: View {
  
  static let totalDistance: CGFloat = 200
  static let moonDistance: CGFloat = totalDistance + 30

  @State var percentage: CGFloat = 0
  @State var reachedMoon = false

  var isFlying: Bool {
    percentage > 0 && !reachedMoon
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

  var congrats: some View {
    VStack {
      Text("Congrats!! 🚀🌙")
      .bold()
      .font(.largeTitle)
      .foregroundColor(.white)
      .padding()
      Spacer()
    }
    .transition(AnyTransition.move(edge: .trailing))
  }

  var buttons: some View {
    Group {
      if reachedMoon {
        Button("Reset") {
          self.percentage = 0
          self.reachedMoon.toggle()
        }
      } else {
        Button("Launch!") {
          withAnimation(.easeInOut(duration: 1)) {
            self.percentage = 1
          }
        }.disabled(isFlying)
      }
    }
    .padding()
  }

  var body: some View {
    VStack {
      ZStack(alignment: .bottomLeading) {
        Color.purple // Background
        if reachedMoon {
          congrats
        }
        moon
        bluePlane
        .modifier(
          Moonshot_FlyModifier(
            totalDistance: Self.totalDistance,
            percentage: percentage
          ) {
            withAnimation {
              self.reachedMoon.toggle()
            }
          }
        )
      }
      .padding()
      buttons
    }
  }
}

struct Moonshot_Previews: PreviewProvider {
  static var previews: some View {
    Moonshot()
  }
}

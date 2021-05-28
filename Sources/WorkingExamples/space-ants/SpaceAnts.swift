import SwiftUI

struct SpaceAnts: View {

  /// Is the ant moving around. Used to kick-off animation.
  @State private var movingAnt = false

  /// Is the ant angry
  @State var angryAnt = false

  /// How many times was the angry ant caught
  @State var score = 0

  private var antBody: some View {
    Ant(angry: $angryAnt)
    .overlay(
      // We use an overlay with minimum opacity to capture taps
      Color.white.opacity(0.01)
      .onTapGesture {
        if angryAnt {
          score += 1
        }
        angryAnt.toggle()
      }
    )
  }

  var body: some View {
    VStack { // Contains title, the moving ant and score
      // Title
      Group {
        if angryAnt {
          Text("CATCH THE ANGRY ANT!!!")
          .foregroundColor(angryAnt ? .red : .yellow)
          .animation(.linear(duration: 8.0).repeatForever(autoreverses: false))
        } else {
          Text("Poke the space ant and she will get angry…")
          .foregroundColor(.yellow)
        }
      }
      .font(.title)
      .padding()

      // Our moving ant
      GeometryReader { proxy in
        antBody
        .modifier(FollowEffect(pct: movingAnt ? 1 : 0, path: InfinityShape.createInfinityPath(in: CGRect(x: 0, y: 0, width: proxy.size.width, height: proxy.size.height))))
        .offset(x: -25, y: 0)
        .animation(.linear(duration: angryAnt ? 8.0 : 20.0).repeatForever(autoreverses: false))
        .onAppear {
          movingAnt.toggle()
        }
      }

      // Current score
      if score > 0 {
        Text("Score: \(score)")
        .font(.title2)
        .foregroundColor(.white)
        .padding()
      }
    }
    // Night sky background
    .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .top, endPoint: .bottom))
  }
}

fileprivate struct Ant: View {

  @Binding var angry: Bool
  @State private var degrees: Double = 0

  var base: some View {
    Image(systemName: "ant.fill")
    .resizable()
    .aspectRatio(contentMode: .fit)
    .frame(width: 50)
    .rotationEffect(.degrees(degrees))
    .foregroundColor(angry ? .red : nil)
    .opacity((degrees + 30) / 60)
  }

  var body: some View {
    Group {
      if angry {
        base
        .animation(Animation.linear(duration: 0.2).repeatForever(autoreverses: true))
        .onAppear {
          self.degrees = -30
        }
      } else {
        base
        .animation(.easeOut(duration: 0.5))
        .onAppear {
          self.degrees = 30
        }
      }
    }
  }
}

fileprivate struct FollowEffect: GeometryEffect {
  var pct: CGFloat = 0
  let path: Path
  
  var animatableData: CGFloat {
    get { return pct }
    set { pct = newValue }
  }

  func effectValue(size: CGSize) -> ProjectionTransform {
    // Calculate rotation angle, by calculating an imaginary line between two points
    // in the path: the current position (1) and a point very close behind in the path (2).
    let pt1 = percentPoint(pct)
    let pt2 = percentPoint(pct - 0.01)
    let a = pt2.x - pt1.x
    let b = pt2.y - pt1.y
    let angle = a < 0 ? atan(Double(b / a)) : atan(Double(b / a)) - Double.pi
    let transform = CGAffineTransform(translationX: pt1.x, y: pt1.y).rotated(by: CGFloat(angle))
    return ProjectionTransform(transform)
  }

  func percentPoint(_ percent: CGFloat) -> CGPoint {
    let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)
    let f = pct > 0.999 ? CGFloat(1-0.001) : pct
    let t = pct > 0.999 ? CGFloat(1) : pct + 0.001
    let tp = path.trimmedPath(from: f, to: t)
    return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
  }
}

fileprivate struct InfinityShape: Shape {
    func path(in rect: CGRect) -> Path {
      InfinityShape.createInfinityPath(in: rect)
    }

    static func createInfinityPath(in rect: CGRect) -> Path {
        let height = rect.size.height
        let width = rect.size.width
        let heightFactor = height/4
        let widthFactor = width/4

        var path = Path()

        path.move(to: CGPoint(x:widthFactor, y: heightFactor * 3))
        path.addCurve(to: CGPoint(x:widthFactor, y: heightFactor), control1: CGPoint(x:0, y: heightFactor * 3), control2: CGPoint(x:0, y: heightFactor))

        path.move(to: CGPoint(x:widthFactor, y: heightFactor))
        path.addCurve(to: CGPoint(x:widthFactor * 3, y: heightFactor * 3), control1: CGPoint(x:widthFactor * 2, y: heightFactor), control2: CGPoint(x:widthFactor * 2, y: heightFactor * 3))

        path.move(to: CGPoint(x:widthFactor * 3, y: heightFactor * 3))
        path.addCurve(to: CGPoint(x:widthFactor * 3, y: heightFactor), control1: CGPoint(x:widthFactor * 4 + 5, y: heightFactor * 3), control2: CGPoint(x:widthFactor * 4 + 5, y: heightFactor))

        path.move(to: CGPoint(x:widthFactor * 3, y: heightFactor))
        path.addCurve(to: CGPoint(x:widthFactor, y: heightFactor * 3), control1: CGPoint(x:widthFactor * 2, y: heightFactor), control2: CGPoint(x:widthFactor * 2, y: heightFactor * 3))

        return path
    }
}

struct SpaceAnts_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Group {
        Ant(angry: .constant(false))
        .previewDisplayName("Space ant")

        Ant(angry: .constant(true))
        .previewDisplayName("Angry ant (use live preview)")
      }
      .previewLayout(.sizeThatFits)
      SpaceAnts()
      .previewDisplayName("Space Ants")
    }
  }
}

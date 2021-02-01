import SwiftUI
import Combine

struct CountDownUp: View {

  @State var percentage = CGFloat(0)
  @State var isCounting = false
  @State var isReversed = false
    
  static let commands = PassthroughSubject<String, Never>()

  var body: some View {
    VStack {
      Spacer()
      EmptyView()
      .modifier(
        CountModifier(
          maxValue: 100,
          timeDuration: 10,
          percentage: $percentage,
          isCounting: $isCounting,
          isReversed: $isReversed
        )
      )
      HStack {
        Button(action: {
          isCounting.toggle()
        }) {
          Image(systemName: isCounting ? "pause.circle.fill" : "play.circle.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 100)
        }
        Button(action: {
          isReversed.toggle()
        }) {
          Image(systemName: isReversed ? "arrowshape.turn.up.right.circle.fill" : "arrowshape.turn.up.backward.2.circle.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 100)
        }
      }
      .frame(maxWidth: .infinity)
      Spacer()
    }
  }
}

fileprivate struct CountModifier: AnimatableModifier {

  var maxValue: CGFloat
  var timeDuration: Double
  @Binding var percentage: CGFloat
  @Binding var isCounting: Bool
  @Binding var isReversed: Bool

  private var percentValue: CGFloat

  init(
    maxValue: CGFloat,
    timeDuration: Double,
    percentage: Binding<CGFloat>,
    isCounting: Binding<Bool>,
    isReversed: Binding<Bool>
  ) {
    self.maxValue = maxValue
    self.timeDuration = timeDuration
    _percentage = percentage
    _isCounting = isCounting
    _isReversed = isReversed
    percentValue = percentage.wrappedValue
  }

  var animatableData: CGFloat {
    get { percentValue }
    set { percentValue = newValue }
  }

  var timeRemaining: Double {
    isReversed
    ? timeDuration * Double(percentValue)
    : timeDuration * Double(1 - percentValue)
  }

  var value: Int {
    Int(percentValue * maxValue)
  }

  func body(content: Content) -> some View {
    if (isReversed && percentValue == 0) || (!isReversed && percentValue == 1) {
      DispatchQueue.main.async {
        percentage = isReversed ? 1 : 0
        withAnimation(.linear(duration: timeDuration)) {
          percentage = isReversed ? 0 : 1
        }
      }
    }

    return actualBody(content)
  }
  
  func actualBody(_ content: Content) -> some View {
    Text("\(value, specifier: "%d")")
    .font(.system(size: 120.0, weight: .bold, design: .monospaced))
    .onChange(of: isCounting) { _ in
      handleStartStop()
    }
    .onChange(of: isReversed) { _ in
      handleReverse()
    }
  }

  func handleStartStop() -> () {
    if isCounting {
      withAnimation(.linear(duration: timeRemaining)) {
        percentage = isReversed ? 0 : 1
      }
    } else {
      withAnimation(.linear(duration: 0)) {
        percentage = percentValue
      }
    }
  }

  func handleReverse() -> () {
    if isCounting {
      withAnimation(.linear(duration: 0)) {
        percentage = percentValue
      }
      withAnimation(.linear(duration: timeRemaining)) {
        percentage = isReversed ? 0 : 1
      }
    }
  }
}

struct CountDownUp_Previews: PreviewProvider {
  static var previews: some View {
    CountDownUp()
  }
}

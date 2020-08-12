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
        Button(isCounting ? "⏸" : "▶️") {
          if #available(iOS 14.0, *) {
            self.isCounting.toggle()
          } else {
            CountDownUp.commands.send("toggleIsCounting")
          }
        }
        Button(isReversed ? "🔽" : "🔼") {
          if #available(iOS 14.0, *) {
            self.isReversed.toggle()
          } else {
            CountDownUp.commands.send("toggleIsReversed")
          }
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
        self.percentage = self.isReversed ? 1 : 0
        withAnimation(.linear(duration: self.timeDuration)) {
          self.percentage = self.isReversed ? 0 : 1
        }
      }
    }
    //if #available(iOS 14.0, *) {
    //  return AnyView(actualBody(content))
    //} else {
    //  return AnyView(actualBody13(content))
    //}
    return actualBody13(content)
  }
  
  //@available(iOS 14.0, *)
  //func actualBody(_ content: Content) -> some View {
  //  Text("\(value, specifier: "%03d")")
  //  .font(.system(.largeTitle, design: .monospaced))
  //  .font(.largeTitle)
  //  .onChange(of: isCounting) { _ in
  //    handleStartStop()
  //  }
  //  .onChange(of: isReversed) { _ in
  //    handleReverse()
  //  }
  //}

  @available(iOS 13.0, *)
  func actualBody13(_ content: Content) -> some View {
    Text("\(value, specifier: "%03d")")
    .font(.system(.largeTitle, design: .monospaced))
    .font(.largeTitle)
    .onReceive(CountDownUp.commands) {
      if $0 == "toggleIsCounting" {
        self.isCounting.toggle()
        self.handleStartStop()
      } else if $0 == "toggleIsReversed" {
        self.isReversed.toggle()
        self.handleReverse()
      }
    }
  }

  func handleStartStop() -> () {
    if isCounting {
      withAnimation(.linear(duration: timeRemaining)) {
        self.percentage = isReversed ? 0 : 1
      }
    } else {
      withAnimation(.linear(duration: 0)) {
        self.percentage = percentValue
      }
    }
  }

  func handleReverse() -> () {
    if isCounting {
      withAnimation(.linear(duration: 0)) {
        self.percentage = percentValue
      }
      withAnimation(.linear(duration: timeRemaining)) {
        self.percentage = isReversed ? 0 : 1
      }
    }
  }
}

struct CountDownUp_Previews: PreviewProvider {
  static var previews: some View {
    CountDownUp()
  }
}

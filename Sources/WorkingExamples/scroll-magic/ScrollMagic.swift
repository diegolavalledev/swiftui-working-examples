import SwiftUI

public struct JumpingTitleBar: View {
  
  private struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = nextValue()
    }
  }

  @State var onTop = true

  var scrollView: some View {
    GeometryReader { g in
      ScrollView(.vertical) {
        Text("""


        Scroll down to see the title bar jump from top to bottom.
        ⬇︎

        Scroll down to see the title bar jump from top to bottom.
        ⬇︎

        Scroll down to see the title bar jump from top to bottom.
        ⬇︎

        ⬇︎

        ⬇︎

        ⬇︎

        ⬇︎

        ⬇︎

        ⬆︎

        ⬆︎

        ⬆︎

        ⬆︎

        ⬆︎

        ⬆︎
        Scroll up to see the title bar jump back to the top.

        ⬆︎
        Scroll up to see the title bar jump back to the top.

        ⬆︎
        Scroll up to see the title bar jump back to the top.
        """)
        .multilineTextAlignment(.center)
        .padding(.top, 60)
        .padding(.bottom, 50)
        .anchorPreference(key: OffsetKey.self, value: .top) {
          g[$0].y
        }
      }
    }
  }

  var topBar: some View {
    VStack {
      Text("Title Bar")
      .font(.largeTitle)
      Text("On top ☝️")
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 35)
    .background(Color(UIColor.systemBackground))
  }
  
  var bottomBar: some View {
    (Text("Title Bar").bold() + Text(" at the bottom 👇"))
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color(UIColor.systemBackground))
    .opacity(onTop ? 0 : 0.85)
  }

  public init() { }

  public var body: some View {
    ZStack {
      scrollView
      .onPreferenceChange(OffsetKey.self) {
        if $0 < -10 {
          withAnimation {
            self.onTop = false
          }
        } else {
          withAnimation {
            self.onTop = true
          }
        }
      }
      VStack {
        if onTop {
          topBar
          .transition(.move(edge: .top))
        }
        Spacer()
        bottomBar
      }
      .edgesIgnoringSafeArea([.top, .bottom])
    }
  }
}

struct JumpingTitleBar_Previews: PreviewProvider {
  static var previews: some View {
    JumpingTitleBar()
  }
}

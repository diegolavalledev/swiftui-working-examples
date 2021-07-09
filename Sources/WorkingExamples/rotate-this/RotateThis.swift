import SwiftUI

struct RotateThis: View {
  var body: some View {
    GeometryReader { p in
      LazyVGrid(
        columns: [GridItem(.adaptive(minimum: getAdaptiveMinWidth(p)), spacing: 0)],
        alignment: .leading,
        spacing: 0
      ) {
        ZStack {
          Color.blue.opacity(0.5)
          Text("You are currently in \(isPortrait(p) ? "portrait" : "landscape") mode. The grid's content is layed out \(isPortrait(p) ? "vertically" : "side-by-side").")
          .padding()
        }
        .frame(height: getHeight(p))
        ZStack {
          Color.red.opacity(0.5)
          #if os(macOS)
            Text("\(isPortrait(p) ? "Widen" : "Narrow") this window to see how the grid adapts.")
            .padding()
          #else
            Text("Rotate the device sideways to see how the grid adapts.\(isPortrait(p) ? " Make sure the rotation lock is not currently activated." : "")")
            .padding()
          #endif
        }
        .frame(height: getHeight(p))
      }
    }
    .edgesIgnoringSafeArea(.top)
  }

  private func isPortrait(_ p: GeometryProxy) -> Bool {
    p.size.width < p.size.height
  }

  private func getAdaptiveMinWidth(_ p: GeometryProxy) -> CGFloat {
    isPortrait(p) ? p.size.width / 2 + 1: p.size.width / 2
  }

  private func getHeight(_ p: GeometryProxy) -> CGFloat {
    isPortrait(p) ? p.size.height / 2 : p.size.height
  }
}

struct RotateThis_Previews: PreviewProvider {
  static var previews: some View {
    RotateThis()
  }
}

import SwiftUI

struct ThatsAWrap: View {

  @State private var height: CGFloat = 0

  @State var boxes = [
    CGSize(width: 50, height: 100)
  ]

  var body: some View {
    VStack {
      HStack {
        Button("Add box") {
          boxes.append(
            CGSize(
              width: Int.random(in: 50 ..< 150),
              height: Int.random(in: 50 ..< 100)
            )
          )
        }
        .padding()
      }
      ScrollView(.vertical) {
        wrappingHStackBody
      }
      .padding()
    }
  }

  var wrappingHStackBody: some View {
    GeometryReader { p in
      WrappingHStack (
        width: p.frame(in: .global).width,
        alignment: .top,
        spacing: 8,
        content: boxes.indices.map { i in
          Rectangle()
          .fill(Color.accentColor)
          .frame(width: boxes[i].width, height: boxes[i].height)
          .onTapGesture {
            boxes.remove(at: i)
          }
        }
      )
      .anchorPreference(
        key: CGFloatPreferenceKey.self,
        value: .bounds,
        transform: {
          p[$0].size.height
        }
      )
    }
    .frame(height: height)
    .onPreferenceChange(CGFloatPreferenceKey.self, perform: {
      height = $0
    })
  }
}

fileprivate struct CGFloatPreferenceKey: PreferenceKey {
  static var defaultValue = CGFloat.zero
  static func reduce(value: inout CGFloat , nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

fileprivate struct WrappingHStack<Content: View>: View {

  var width: CGFloat
  var alignment: Alignment
  var spacing: CGFloat
  var content: [Content]

  var laneBounds: [Int] {
    let (laneBounds, _, _) =
      content.reduce(([], 0, width)) {
        (accum, item) -> ([Int], Int, CGFloat) in
        var (laneBounds, index, laneWidth) = accum

        // Let's measure the item's size
        #if os(iOS)
        let hostingController = UIHostingController(rootView: item)
        #else
        let hostingController = NSHostingController(rootView: item)
        #endif

        let itemWidth = hostingController
          .view.intrinsicContentSize.width

        if laneWidth + itemWidth > width {
          laneWidth = itemWidth
          laneBounds.append(index)
        } else {
          laneWidth += itemWidth + spacing
        }
        index += 1
        return (laneBounds, index, laneWidth)
    }
    return laneBounds
  }

  var totalLanes: Int {
    laneBounds.count
  }

  func lowerBound(lane i: Int) -> Int {
    laneBounds[i]
  }

  func upperBound(lane i: Int) -> Int {
    i == totalLanes - 1 ? content.count : laneBounds[i + 1]
  }

  var body: some View {
    VStack {
      ForEach(0 ..< totalLanes, id: \.self) { i in
        // Lane
        HStack(alignment: alignment.vertical, spacing: spacing) {
          // Lane items
          ForEach(lowerBound(lane: i) ..< upperBound(lane: i), id: \.self) {
            content[$0]
          }
        }
        .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment.horizontal, vertical: .center))
      }
    }
  }
}

extension CGSize: Identifiable {
  public var id: some Hashable {
    "\(width) \(height)"
  }
}

struct ThatsAWrap_Previews: PreviewProvider {
  static var previews: some View {
    ThatsAWrap()
  }
}

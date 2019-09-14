import SwiftUI

struct Toggles: View {

  struct Model: Identifiable {
    var id: String // Also used as label
    var on = false
  }

  static let all = [
    Model(id: "foo"),
    Model(id: "bar"),
    Model(id: "baz"),
  ]

  @State var available = Self.all

  var labels: String {
    available
    .filter { $0.on }
    .map { $0.id }
    .joined(separator: " ")
  }
  
  func makeBinding(_ item: Model) -> Binding<Bool> {
    let i = self.available.firstIndex { $0.id == item.id }!
    return .init(
      get: { self.available[i].on },
      set: { self.available[i].on = $0 }
    )
  }

  func makeUnavailable(_ item: Model) {
    self.available.removeAll { $0.id == item.id }
  }

  func isAvailable(_ item: Model) -> Bool {
    available.contains { $0.id == item.id }
  }

  var body: some View {
    VStack {
      if available.count > 0 {
        VStack {
          Text("Labels ") + Text("turned on").bold()
          if labels == "" {
            Text("No label is currently turned on")
            .italic()
          } else {
            Text("\(labels)")
          }
        }.padding()
        Divider()
        ForEach(Self.all) { item in
          if self.isAvailable(item) {
            HStack {
              Toggle(item.id,
                isOn: self.makeBinding(item)
              ).fixedSize()
              Button("remove") {
                self.makeUnavailable(item)
              }
            }
          }
        }
      } else {
        Text("No labels available")
        .italic().padding()
      }
      Divider()
      HStack {
        ForEach(Self.all) { item in
          Button(item.id) {
            self.available.append(item)
          }
          .environment(\.isEnabled, !self.isAvailable(item))
        }
      }
      Text("Tap on each label to make it available/unavailable)")
        .fixedSize(horizontal: false, vertical: true)
        .padding()
      Spacer()
    }
  }
}

struct Toggles_Previews: PreviewProvider {
  static var previews: some View {
    Toggles()
  }
}

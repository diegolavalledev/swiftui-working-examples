import SwiftUI

struct ContentView: View {

  struct Example: Identifiable {
    var id: String
    var view: AnyView
    
    init<V: View>(_ id: String, view: V) {
      self.id = id
      self.view = AnyView(view)
    }
  }

  static var examples = [
    Example("animation-ended", view: ImprovedPlaneMoonScene()),
    Example("combine-form-validation", view: SignUpForm()),
    Example("scroll-magic", view: JumpingTitleBar())
  ]

  @State var example: Example?

  struct ExampleRow: View {

    var example: Example
    @Binding var selected: Example?

    var body: some View {
      Button("\(example.id)") {
        self.selected = self.example
      }
      .padding()
    }
  }

  var body: some View {
    List {
      ForEach(Self.examples) {
        ExampleRow(example: $0, selected: self.$example)
      }
    }
    .sheet(item: $example) {
      $0.view
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

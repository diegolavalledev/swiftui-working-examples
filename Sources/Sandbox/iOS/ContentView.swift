import SwiftUI

struct ContentView: View {

  @State var example: Example?

  struct ExampleRow: View {

    var example: Example
    @Binding var selected: Example?

    var body: some View {
      Button(example.description) {
        self.selected = self.example
      }
      .padding()
    }
  }

  var body: some View {
    List {
      ForEach(Example.all) {
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

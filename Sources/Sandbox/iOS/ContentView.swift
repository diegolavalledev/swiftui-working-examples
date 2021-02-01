import SwiftUI

extension Example.Name: Identifiable {
  public var id: Example.Name.RawValue { self.rawValue }
}

struct ContentView: View {

  @State var exampleName: Example.Name?

  struct ExampleRow: View {

    let name: Example.Name
    @Binding var selection: Example.Name?

    var body: some View {
      Button(name.rawValue) {
        selection = name
      }
      .padding()
    }
  }

  var body: some View {
    List {
      ForEach(Example.Name.allCases) {
        ExampleRow(name: $0, selection: $exampleName)
      }
    }
    .sheet(item: $exampleName) {
      Example($0)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

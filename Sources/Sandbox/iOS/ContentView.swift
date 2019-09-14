import SwiftUI

struct ContentView: View {

  @State var example: String!
  @State var showSheet = false

  struct ExampleRow: View {

    var name: String
    var onPressed: () -> ()

    var body: some View {
      Button("\(name)", action: onPressed)
    }
  }

  var body: some View {
    VStack {
      ForEach([
        "animation-ended",
        "combine-form-validation",
        "scroll-magic",
      ], id: \.self) { example in
        ExampleRow(name: example) {
          self.example = example
          self.showSheet.toggle()
        }
      }
    }
    .sheet(isPresented: $showSheet) {
      if self.example == "animation-ended" {
        ImprovedPlaneMoonScene()
      } else if self.example == "combine-form-validation" {
        SignUpForm()
      } else if self.example == "scroll-magic" {
        JumpingTitleBar()
      } else {
        Text("N/A")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

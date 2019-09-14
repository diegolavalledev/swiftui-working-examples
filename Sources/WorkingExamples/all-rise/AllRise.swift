import SwiftUI

struct AllRise: View {
  
  @State var textFieldValue = ""

  @ObservedObject var keyboardProps = KeyboardProperties.shared
  
  var kbHeight: CGFloat {
    keyboardProps.frame.height
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("We monitor the state of the software keyboard. When it comes up, we react by shifting the text field upwards.")
      Spacer().fixedSize()
      Text("Current keyboard height: ").italic() + Text("\(kbHeight, specifier: "%.2f")")
      Spacer()

      Group {
        Text("The following field would otherwise be covered by the software keyboard coming up.")
        TextField("Enter some text", text: self.$textFieldValue)
        .textFieldStyle(RoundedBorderTextFieldStyle())
      }
      .offset(y: -kbHeight)
      .animation(.easeIn(duration: 0.2))
    }
    .padding()
  }
}

struct AllRise_Previews: PreviewProvider {
  static var previews: some View {
    Text("Use Live Preview to present sheet")
    .sheet(isPresented: .constant(true)) {
      AllRise()
    }
  }
}

import SwiftUI

struct RealtimeJson: View {

  @ObservedObject var landmark = LandmarkModel("Eiffel Tower")

  var body: some View {
    NavigationView {
      VStack {
        TextField("Place", text: $landmark.site)
        Toggle("Visited?", isOn: $landmark.visited)
        TextField("JSON", text: landmark.jsonBinding)
        Spacer()
      }
      .padding()
      .navigationBarTitle("Landmark")
    }
  }
}

struct RealtimeJson_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RealtimeJson()
    }
  }
}

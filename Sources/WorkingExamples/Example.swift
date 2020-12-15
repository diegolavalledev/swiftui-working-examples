import SwiftUI

public struct Example: View {

  public enum Name: String, CaseIterable {
#if os(iOS)
    case moonshot = "moonshot"
    case fakeSignup = "fake-signup"
    case scrollMagic = "scroll-magic"
    case realtimeJson = "realtime-json"
    case allRise = "all-rise"
    case toggles = "toggles"
    case faveDishes = "fave-dishes"
    case countDownUp = "count-down-up"
    case thatsAWrap = "thats-a-wrap"
#else
    case faveDishes = "fave-dishes"
#endif
  }

  let name: Name

  public init(_ name: Name) {
    self.name = name
  }

  public init?(_ nameAsString: String) {
    guard let name = Name(rawValue: nameAsString) else {
      return nil
    }
    self.init(name)
  }

  public var body: some View {
#if os(iOS)
    switch(name) {
      case .moonshot:
        Moonshot()
      case .fakeSignup:
        FakeSignup()
      case .scrollMagic:
        ScrollMagic()
      case .realtimeJson:
        RealtimeJson()
      case .allRise:
        AllRise()
      case .toggles:
        Toggles()
      case .faveDishes:
        FaveDishes()
      case .countDownUp:
        CountDownUp()
      case .thatsAWrap:
        ThatsAWrap()
    }
#else
    switch(name) {
      case .faveDishes:
        FaveDishes()
    }
#endif
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Example(.faveDishes)
  }
}

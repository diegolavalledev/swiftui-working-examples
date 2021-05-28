import SwiftUI

public struct Example: View {

  public enum Name: String, CaseIterable {
#if os(iOS)
    case fakeSignup = "fake-signup"
    case scrollMagic = "scroll-magic"
    case realtimeJson = "realtime-json"
    case allRise = "all-rise"
    case toggles = "toggles"
    case countDownUp = "count-down-up"
    case thatsAWrap = "thats-a-wrap"
#endif
    case moonshot = "moonshot"
    case faveDishes = "fave-dishes"
    case loopyCarousel = "loopy-carousel"
    case spaceAnts = "space-ants"
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
    switch(name) {

#if os(iOS)
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
      case .countDownUp:
        CountDownUp()
      case .thatsAWrap:
        ThatsAWrap()
#endif
      case .moonshot:
        Moonshot()
      case .faveDishes:
        FaveDishes()
      case .loopyCarousel:
        LoopyCarousel()
      case .spaceAnts:
        SpaceAnts()
    }
  }
}

struct Example_Previews: PreviewProvider {
  static var previews: some View {
    Example(.moonshot)
  }
}

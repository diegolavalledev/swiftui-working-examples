import SwiftUI

public struct Example: Identifiable, CustomStringConvertible {
  public var id: Key
  public var view: AnyView
  
  public enum Key: String {
    
    case moonshot = "/examples/moonshot"
    case fakeSignup = "/examples/fake-signup"
    case scrollMagic = "/examples/scroll-magic"
    case realtimeJson = "/examples/realtime-json"
    case allRise = "/examples/all-rise"
    case toggles = "/examples/toggles"
    case faveDishes = "/examples/fave-dishes"
  }

  public var description: String {
    id.rawValue
  }

  init<V: View>(_ id: Key, view: V) {
    self.id = id
    self.view = AnyView(view)
  }
  
#if os(macOS)
  public static var byKey: KeyValuePairs = [
    Key.toggles: Example(.toggles, view: Toggles()),
    Key.faveDishes: Example(.faveDishes, view: FaveDishes()),
  ]
#endif
#if os(iOS)
  public static var byKey: KeyValuePairs = [
    Key.moonshot: Example(.moonshot, view: Moonshot()),
    Key.fakeSignup: Example(.fakeSignup, view: FakeSignup()),
    Key.scrollMagic: Example(.scrollMagic, view: ScrollMagic()),
    Key.realtimeJson: Example(.realtimeJson, view: RealtimeJson()),
    Key.allRise: Example(.allRise, view: AllRise()),
    Key.toggles: Example(.toggles, view: Toggles()),
    Key.faveDishes: Example(.faveDishes, view: FaveDishes()),
  ]
#endif

  public static func withPermalink(_ permalink: String) -> Self? {
    guard
      let key = Key.init(rawValue: permalink),
      let pair = byKey.first(where: { $0.key == key})
    else {
      return nil
    }
    return pair.value
  }

  public static var all: [Self] {
    byKey.map { $0.value }
  }

}

import Combine
import Foundation
import SwiftUI

class LandmarkModel: Codable, ObservableObject {

  @Published var site: String
  @Published var visited: Bool = false
  
  init(_ site: String) {
    self.site = site
  }

  // MARK: - Codable
  enum CodingKeys: String, CodingKey {
    case site
    case visited
  }

  // MARK: - Codable
  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    site = try values.decode(String.self, forKey: .site)
    visited = try values.decode(Bool.self, forKey: .visited)
  }

  // MARK: - Encodable
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(site, forKey: .site)
    try container.encode(visited, forKey: .visited)
  }

  // Encode this instance as JSON data
  var asJsonData: Data? {
    try? JSONEncoder().encode(self)
  }
  
  // Create an instance from JSON data
  static func fromJsonData(_ json: Data) -> Self? {
    guard let decoded = try? JSONDecoder().decode(Self.self, from: json) else {
      return nil
    }
    return decoded
  }
  
  // MARK: - Working example support

  func merge(_ landmark: LandmarkModel) {
    site = landmark.site
    visited = landmark.visited
  }

  // Encode this instance as JSON string
  var asJson: String? {
    guard let jsonData = asJsonData else {
      return nil
    }
    return String(bytes: jsonData, encoding: .utf8)
  }
  
  // Create an instance from JSON string
  static func fromJson(_ jsonString: String) -> Self? {
    guard let jsonData = jsonString.data(using: .utf8), let decoded = fromJsonData(jsonData) else {
      return nil
    }
    return decoded
  }
  
  var jsonBinding: Binding<String> {
    Binding<String>(
      get: { () -> String in
        guard let asJson = self.asJson else {
          return "null"
        }
        return asJson
      },
      set: {
        guard let landmark = Self.fromJson($0) else {
          return
        }
        self.merge(landmark)
      }
    )
  }
}

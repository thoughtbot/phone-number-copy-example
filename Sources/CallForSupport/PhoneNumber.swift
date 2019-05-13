import Foundation

struct PhoneNumber: RawRepresentable {
  let rawValue: String

  var url: URL {
    var components = URLComponents(string: rawValue)!
    components.scheme = "tel"
    return components.url!
  }
}

extension PhoneNumber {
  init(_ rawValue: String) {
    self.rawValue = rawValue
  }
}

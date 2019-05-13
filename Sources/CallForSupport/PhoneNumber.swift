struct PhoneNumber: RawRepresentable {
  let rawValue: String
}

extension PhoneNumber {
  init(_ rawValue: String) {
    self.rawValue = rawValue
  }
}

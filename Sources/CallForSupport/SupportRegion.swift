import Foundation

struct SupportRegion {
  var regionCodes: [String]
  var phoneNumber: PhoneNumber

  var localizedName: String {
    return regionCodes
      .map(localizedDescription(forRegionCode:))
      .joined(separator: ", ")
  }
}

private func localizedDescription(forRegionCode code: String) -> String {
  return Locale.current.localizedString(forRegionCode: code) ?? code
}

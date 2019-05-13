import UIKit

final class SupportViewController: UITableViewController {
  let regions = [
    SupportRegion(regionCodes: ["US", "CA"], phoneNumber: PhoneNumber("+1-555-123-4567")),
    SupportRegion(regionCodes: ["AU"], phoneNumber: PhoneNumber("+61-1800-123-456")),
    SupportRegion(regionCodes: ["GB"], phoneNumber: PhoneNumber("+44-800-123-4567")),
  ]

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return regions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let region = self.regions[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Support Region", for: indexPath)
    cell.textLabel?.text = region.localizedName
    cell.detailTextLabel?.text = region.phoneNumber.rawValue
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

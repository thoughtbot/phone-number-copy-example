import UIKit

final class SupportViewController: UITableViewController {
  let regions = [
    SupportRegion(regionCodes: ["US", "CA"], phoneNumber: PhoneNumber("+1-555-123-4567")),
    SupportRegion(regionCodes: ["AU"], phoneNumber: PhoneNumber("+61-1800-123-456")),
    SupportRegion(regionCodes: ["GB"], phoneNumber: PhoneNumber("+44-800-123-4567")),
  ]

  private var isOpeningPhoneURL = false

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(clearSelection),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return regions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let region = regions[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Support Region", for: indexPath)
    cell.textLabel?.text = region.localizedName
    cell.detailTextLabel?.text = region.phoneNumber.rawValue
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let region = regions[indexPath.row]

    UIApplication.shared.open(region.phoneNumber.url) { success in
      if success {
        self.isOpeningPhoneURL = true
      } else {
        // TODO: handle phone call failure
      }
    }
  }

  @objc func clearSelection() {
    guard let indexPath = tableView.indexPathForSelectedRow, isOpeningPhoneURL else { return }
    isOpeningPhoneURL = false
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

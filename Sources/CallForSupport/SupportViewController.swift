import UIKit

final class SupportViewController: UITableViewController {
  let regions = [
    SupportRegion(regionCodes: ["US", "CA"], phoneNumber: PhoneNumber("+1-555-123-4567")),
    SupportRegion(regionCodes: ["AU"], phoneNumber: PhoneNumber("+61-1800-123-456")),
    SupportRegion(regionCodes: ["GB"], phoneNumber: PhoneNumber("+44-800-123-4567")),
  ]

  private var isOpeningPhoneURL = false
  private var menuTimer: Timer?

  override var canBecomeFirstResponder: Bool {
    return true
  }

  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return action == #selector(copy(_:))
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(clearSelection),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(clearSelection),
      name: UIMenuController.willHideMenuNotification,
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

  override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    menuTimer = Timer.scheduledTimer(
      timeInterval: 0.5,
      target: self,
      selector: #selector(showMenu),
      userInfo: indexPath,
      repeats: false
    )
    return true
  }

  override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    cancelMenuTimer()
  }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return UIMenuController.shared.isMenuVisible ? nil : indexPath
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let region = regions[indexPath.row]
    defer { cancelMenuTimer() }

    UIApplication.shared.open(region.phoneNumber.url) { success in
      if success {
        self.isOpeningPhoneURL = true
      } else if let cell = tableView.cellForRow(at: indexPath) {
        self.showMenu(cell)
      } else {
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
  }

  @objc func clearSelection(_ notification: Notification) {
    guard let indexPath = tableView.indexPathForSelectedRow else { return }

    switch notification.name {
    case UIApplication.didBecomeActiveNotification where isOpeningPhoneURL:
      isOpeningPhoneURL = false
      tableView.deselectRow(at: indexPath, animated: true)
    case UIMenuController.willHideMenuNotification:
      tableView.deselectRow(at: indexPath, animated: true)
    default:
      break
    }
  }

  @objc func showMenu(_ sender: Any) {
    let cell: UITableViewCell
    defer { cancelMenuTimer() }

    switch sender {
    case let timer as Timer where timer == menuTimer:
      let indexPath = timer.userInfo as! IndexPath
      cell = tableView.cellForRow(at: indexPath)!
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    case let selectedCell as UITableViewCell:
      cell = selectedCell
    default:
      return
    }

    let menu = UIMenuController.shared
    menu.setTargetRect(cell.frame, in: tableView)
    menu.setMenuVisible(true, animated: true)
  }

  private func cancelMenuTimer() {
    menuTimer?.invalidate()
    menuTimer = nil
  }

  override func copy(_ sender: Any?) {
    guard let indexPath = tableView.indexPathForSelectedRow else { return }
    let region = regions[indexPath.row]
    UIPasteboard.general.string = region.phoneNumber.rawValue
  }
}

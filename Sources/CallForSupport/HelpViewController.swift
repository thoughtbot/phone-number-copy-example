import UIKit

enum HelpRow: String, CaseIterable {
  case callSupport = "Call Support"
}

final class HelpViewController: UITableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return HelpRow.allCases.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = HelpRow.allCases[indexPath.row]
    return tableView.dequeueReusableCell(withIdentifier: row.rawValue, for: indexPath)
  }
}

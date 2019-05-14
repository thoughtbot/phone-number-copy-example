import UIKit

final class SupportRegionCell: UITableViewCell {
  @IBOutlet private var titleLabel: UILabel?
  @IBOutlet private var subtitleLabel: UILabel?

  override var textLabel: UILabel? {
    return titleLabel ?? super.textLabel
  }

  override var detailTextLabel: UILabel? {
    return subtitleLabel ?? super.detailTextLabel
  }
}

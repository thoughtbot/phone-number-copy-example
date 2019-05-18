import UIKit

@objc public final class LongPressTableViewDelegate: NSObject {
  private let unforwardedSelectors: Set<Selector> = [
    #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:)),
    #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:)),
    #selector(UITableViewDelegate.tableView(_:didSelectRowAt:)),
  ]

  private let action: Selector
  private let target: Any?
  private var timer: Timer?

  @objc public private(set) var indexPath: IndexPath!
  @objc public var minimumPressDuration: TimeInterval = 0.5
  @objc public weak var underlyingDelegate: UITableViewDelegate?

  @objc public init(target: Any?, action: Selector) {
    self.target = target
    self.action = action
  }

  public func decorate(_ delegate: inout UITableViewDelegate?) {
    underlyingDelegate = delegate
    delegate = self
  }

  override public func responds(to aSelector: Selector!) -> Bool {
    return super.responds(to: aSelector) || underlyingDelegate?.responds(to: aSelector) ?? false
  }

  override public func forwardingTarget(for aSelector: Selector!) -> Any? {
    if unforwardedSelectors.contains(aSelector) {
      return nil
    } else if let underlyingDelegate = underlyingDelegate {
      return underlyingDelegate
    } else {
      return super.forwardingTarget(for: aSelector)
    }
  }

  @objc private func longPress(_ timer: Timer) {
    indexPath = (timer.userInfo as! IndexPath)
    defer { indexPath = nil; self.timer = nil }
    UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
  }
}

extension LongPressTableViewDelegate: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    let shouldHighlight = underlyingDelegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
    if shouldHighlight {
      timer = Timer.scheduledTimer(
        timeInterval: minimumPressDuration,
        target: self,
        selector: #selector(longPress),
        userInfo: indexPath,
        repeats: false
      )
    }
    return shouldHighlight
  }

  public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    cancelTimer()
    underlyingDelegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    cancelTimer()
    underlyingDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
  }

  private func cancelTimer() {
    if let timer = timer {
      timer.invalidate()
      self.timer = nil
    }
  }
}

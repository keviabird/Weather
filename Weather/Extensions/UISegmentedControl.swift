
import UIKit

extension UISegmentedControl {
    /// Tint color doesn't have any effect on iOS 13.
    func oldstylish() {
        if #available(iOS 13, *) {
            let tintColorImage = UIImage(color: tintColor)
            setBackgroundImage(UIImage(color: backgroundColor ?? .clear), for: .normal, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: .selected, barMetrics: .default)
            setBackgroundImage(UIImage(color: tintColor.withAlphaComponent(0.2)), for: .highlighted, barMetrics: .default)
            setBackgroundImage(tintColorImage, for: [.highlighted, .selected], barMetrics: .default)
            setTitleTextAttributes([.foregroundColor: tintColor ?? .blue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
            setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
            setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            layer.borderWidth = 1
            layer.borderColor = tintColor.cgColor
        }
    }
}


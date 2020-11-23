
import Foundation

final class SettingsBuilder {
    
    static func build() -> SettingsViewController {
        let view = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let presenter = SettingsPresenter(with: view)
        view.presenter = presenter
        return view
    }
}

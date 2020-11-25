
import Foundation

final class SettingsBuilder {
    
    static func build(model: ModelInput) -> SettingsViewController {
        let view = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let presenter = SettingsPresenter(with: view)
        presenter.model = model
        view.presenter = presenter
        return view
    }
}


import Foundation

final class LanguageBuilder {
    
    static func build(model: ModelInput) -> LanguageViewController {
        let view = LanguageViewController(nibName: "LanguageViewController", bundle: nil)
        let presenter = LanguagePresenter(with: view)
        presenter.model = model
        view.presenter = presenter
        return view
    }
}

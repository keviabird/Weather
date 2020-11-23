
import Foundation

final class LanguageBuilder {
    
    static func build() -> LanguageViewController {
        let view = LanguageViewController(nibName: "LanguageViewController", bundle: nil)
        let presenter = LanguagePresenter(with: view)
        view.presenter = presenter
        return view
    }
}

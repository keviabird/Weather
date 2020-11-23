
import Foundation

final class MainBuilder {
    
    static func build() -> MainViewController {
        let view = MainViewController(nibName: "MainViewController", bundle: nil)
        let presenter = MainPresenter(with: view)
        view.presenter = presenter
        return view
    }
}


import Foundation

final class MainBuilder {
    
    static func build(model: ModelInput) -> MainViewController {
        let view = MainViewController(nibName: "MainViewController", bundle: nil)
        let presenter = MainPresenter(with: view)
        presenter.model = model
        view.presenter = presenter
        return view
    }
}

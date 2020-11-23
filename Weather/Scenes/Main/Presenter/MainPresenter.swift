
import UIKit

protocol MainPresenterInput {
    func settingsDidTapped()
    func viewDidLoad()
}

protocol MainPresenterOutput {
    func getNavigationController() -> UINavigationController?
    func localize()
    func update(weather: Weather)
    func update(forecasts: [DayForecast])
    func updateCity(_ city: String)
}

class MainPresenter {
    
    var view: MainPresenterOutput?
    
    init(with view: MainPresenterOutput) {
        self.view = view
    }
    
}

extension MainPresenter: MainPresenterInput {
    
    func settingsDidTapped() {
        let settingsController = SettingsBuilder.build()
        view?.getNavigationController()?.pushViewController(settingsController, animated: true)
    }
    
    func viewDidLoad() {
        Model.shared.addObserver(self)
        Model.shared.update(false)
    }
    
}

extension MainPresenter: ModelOutput {
    func cityUpdated(_ city: String) {
        view?.updateCity(city)
    }
    
    func currentWeatherUpdated(_ weather: Weather) {
        view?.update(weather: weather)
    }
    
    func forecastUpdated(_ forecast: [DayForecast]) {
        view?.update(forecasts: forecast)
    }
    
    func languageUpdated(_ language: Language) {
        view?.localize()
    }
    
    func getName() -> String {
        return "MainPresenter"
    }
    
    func errorOccured(_ error: Error) {
        let alert = UIAlertController.init(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        view?.getNavigationController()?.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    func unitsUpdated(_ units: Units) {}
}

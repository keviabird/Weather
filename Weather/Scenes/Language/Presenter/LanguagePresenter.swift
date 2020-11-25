
import UIKit

protocol LanguagePresenterInput {
    func viewDidLoad()
    func languageSelected(_ language: Language)
}

protocol LanguagePresenterOutput {
    func getNavigationController() -> UINavigationController?
    func localize()
    func setLanguage(_ language: Language)
}

class LanguagePresenter {
    
    var view: LanguagePresenterOutput?
    var model: Model!
    
    init(with view: LanguagePresenterOutput) {
        self.view = view
    }
    
}

extension LanguagePresenter: LanguagePresenterInput {
    
    func viewDidLoad() {
        model.addObserver(self)
        self.languageSelected(model.getSettings().language)
    }
    
    func languageSelected(_ language: Language) {
        model.setLanguage(language)
    }
    
}

extension LanguagePresenter: ModelOutput {
    
    func languageUpdated(_ language: Language) {
        view?.setLanguage(language)
        view?.localize()
    }
    
    func getName() -> String {
        return "LanguagePresenter"
    }
    
    func cityUpdated(_ city: String) {}
    func currentWeatherUpdated(_ weather: Weather) {}
    func forecastUpdated(_ forecast: [DayForecast]) {}
    func unitsUpdated(_ units: Units) {}
    func errorOccured(_ error: Error) {}
    
}

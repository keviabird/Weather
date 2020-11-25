
import UIKit

protocol SettingsPresenterInput {
    func viewDidLoad()
    func languageDidTapped()
    func unitSelected(_ unit: Units)
    func getSegmentedControlCellModel() -> SegmentedControlCellModel
}

protocol SettingsPresenterOutput {
    func getNavigationController() -> UINavigationController?
    func setLanguage(_ language: Language)
    func setUnit(_ unit: Units)
}

class SettingsPresenter {
    
    var view: SettingsPresenterOutput?
    var model: Model!
    
    init(with view: SettingsPresenterOutput) {
        self.view = view
    }
    
}

extension SettingsPresenter: SettingsPresenterInput {
    
    func viewDidLoad() {
        model.addObserver(self)
        view?.setLanguage(model.getSettings().language)
        view?.setUnit(model.getSettings().units)
    }
    
    
    func languageDidTapped() {
        let languageView = LanguageBuilder.build(model: model)
        view?.getNavigationController()?.pushViewController(languageView, animated: true)
    }
    
    func unitSelected(_ unit: Units) {
        model.setUnits(unit)
    }
    
    func getSegmentedControlCellModel() -> SegmentedControlCellModel {
        var titles: [String] = []
        let values = Units.allCases
        values.forEach { (unit) in
            titles.append(unit.getTitle())
        }
        let index = values.firstIndex(of: model.getSettings().units) ?? 0
        return SegmentedControlCellModel(titles: titles, values: values, selected: index)
    }
    
}

extension SettingsPresenter: ModelOutput {
    
    func languageUpdated(_ language: Language) {
        view?.setLanguage(language)
    }
    
    func getName() -> String {
        return "SettingsPresenter"
    }
    
    func cityUpdated(_ city: String) {}
    func unitsUpdated(_ units: Units) {}
    func currentWeatherUpdated(_ weather: Weather) {}
    func forecastUpdated(_ forecast: [DayForecast]) {}
    func errorOccured(_ error: Error) {}
    
    
}

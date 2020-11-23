
import Foundation

struct Settings {
    var language: Language = Language(rawValue: UserDefaults.standard.string(forKey: "AppleLanguage") ?? Language.en.rawValue) ?? .en
    var units: Units = Units(rawValue: UserDefaults.standard.string(forKey: "GRWeatherUnits") ?? Units.metric.rawValue) ?? .metric
    var longitude: Double
    var latitude: Double
}


import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func localized() -> String {
        
        let locale = UserDefaults.standard.string(forKey: "AppleLanguage") ?? "en"
        guard let bundlePath = Bundle.main.path(forResource: locale, ofType: "lproj"),
              let bundle = Bundle(path: bundlePath) else {
                return Bundle.main.localizedString(forKey: self, value: self, table: "Localizable")
        }
        return bundle.localizedString(forKey: self, value: self, table: "Localizable")
    }
}

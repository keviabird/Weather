
import Foundation

protocol ModelOutput: AnyObject {
    
    func cityUpdated(_ city: String)
    func currentWeatherUpdated(_ weather: Weather)
    func forecastUpdated(_ forecast: [DayForecast])
    func languageUpdated(_ language: Language)
    func unitsUpdated(_ units: Units)
    func getName() -> String
    func errorOccured(_ error: Error)
}

class WeakModelOutput {
  weak var value : ModelOutput?
  init (value: ModelOutput) {
    self.value = value
  }
}

protocol ModelInput {
    func addObserver(_ observer: ModelOutput)
    func update(_ silent: Bool)
    func getLanguage() -> Language
    func getUnits() -> Units
    func setLanguage(_ language: Language)
    func setUnits(_ units: Units)
}

class Model: NSObject, ModelInput {
    
    private var settings: Settings = Settings(longitude: 0.1277, latitude: 51.5074)
    private var city: String?
    private let timeFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()
    private var locationService: LocationServiceInput!
    private var weatherService: WeatherServiceInput!
    
    private var delegates = [WeakModelOutput]()

    override init() {
        super.init()
        timeFormatter.dateFormat = "HH:mm a"
        timeFormatter.amSymbol = "AM"
        timeFormatter.pmSymbol = "PM"
        dayFormatter.dateFormat = "EEEE"
        locationService = LocationService(delegate: self)
        if let locationService = locationService as? LocationService {
            locationService.startService()
        }
        weatherService = WeatherService(delegate: self)
    }
    
    func addObserver(_ observer: ModelOutput) {
        removeObserver(observer)
        delegates.append(WeakModelOutput(value: observer))
    }
    
    func removeObserver(_ observer: ModelOutput) {
        delegates.removeAll { (existing) -> Bool in
            observer.getName() == existing.value?.getName()
        }
    }
    
    func getLanguage() -> Language {
        return settings.language
    }
    
    func getUnits() -> Units {
        return settings.units
    }
    
    func setLanguage(_ language: Language) {
        UserDefaults.standard.set(language.rawValue, forKey: "AppleLanguage")
        settings.language = language
        dayFormatter.locale = Locale(identifier: getLanguage().rawValue)
        timeFormatter.locale = Locale(identifier: getLanguage().rawValue)
        update(false)
        locationService.updateCity()
        delegates.forEach { (observer) in
            observer.value?.languageUpdated(language)
        }
    }
    
    func setUnits(_ units: Units) {
        UserDefaults.standard.set(units.rawValue, forKey: "GRWeatherUnits")
        settings.units = units
        update(false)
        delegates.forEach { (observer) in
            observer.value?.unitsUpdated(units)
        }
    }
    
    func update(_ silent: Bool = true) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let weakSelf = self {
                weakSelf.weatherService.getWeather(weakSelf.settings, silent: silent)
                weakSelf.weatherService.getForecast(weakSelf.settings, silent: silent)
            }
        }
    }
    
    func jsonToEntity(_ json: WeatherJSON?) -> Weather? {
        if let json = json {
            var weather = Weather()
            weather.sunrise = "\("Sunrise".localized()): \(timeFormatter.string(from: Date.init(timeIntervalSince1970: json.sunrise ?? 0)))"
            weather.sunset = "\("Sunset".localized()): \(timeFormatter.string(from: Date.init(timeIntervalSince1970: json.sunset ?? 0)))"
            weather.weatherName = json.weatherName.capitalizingFirstLetter()
            weather.weatherIcon = json.weatherIcon
            weather.temperature = "\(Int(json.temperature)) \(degrees())"
            weather.visibility = "\("Visibility".localized()): \(json.visibility) \(visibility())"
            weather.wind = "\("Wind".localized()): \(wind(json.windDegrees)) \(json.windSpeed) \(speed())"
            return weather
        }
        return nil
    }
    
    func jsonToEntity(_ json: [WeatherJSON]?) -> [DayForecast]? {
        if let json = json {
            var forecast: [DayForecast] = []
            var currentForecast: DayForecast?
            for item in json {
                let weather = forecastToEntity(item)
                if currentForecast == nil || currentForecast?.day != weather.weekDay {
                    if let currentForecast = currentForecast {
                        forecast.append(currentForecast)
                    }
                    currentForecast = DayForecast(day: weather.weekDay ?? "", weather: [])
                }
                currentForecast?.weather.append(weather)
            }
            if let currentForecast = currentForecast {
                forecast.append(currentForecast)
            }
            return forecast
        }
        return nil
    }
    
    func forecastToEntity(_ json: WeatherJSON) -> Weather {
        var weather = Weather()
        weather.weatherName = "\(json.weatherName.capitalizingFirstLetter()), \(Int(json.temperature)) \(degrees())"
        weather.weatherIcon = json.weatherIcon
        weather.weekDay = dayFormatter.string(from: Date.init(timeIntervalSince1970: json.date))
        weather.time = timeFormatter.string(from: Date.init(timeIntervalSince1970: json.date))
        return weather
    }
    
    func degrees() -> String {
        switch settings.units {
        case .imperial:
            return "ºF"
        case .metric:
            return "ºC"
        }
    }
    
    func visibility() -> String {
        switch settings.units {
        case .imperial:
            return "mi".localized()
        case .metric:
            return "m".localized()
        }
    }
    
    func speed() -> String {
        switch settings.units {
        case .imperial:
            return "mph".localized()
        case .metric:
            return "mps".localized()
        }
    }
    
    func wind(_ degrees: Int) -> String {
        
        if 348 <= degrees, degrees <= 360  { return "N".localized() }
        else if 0 <= degrees, degrees <= 11 { return "N".localized() }
        else if 11 < degrees, degrees <= 33 { return "NNE".localized() }
        else if 33 < degrees, degrees <= 56 { return "NE".localized() }
        else if 56 < degrees, degrees <= 78 { return "ENE".localized() }
        else if 78 < degrees, degrees <= 101 { return "E".localized() }
        else if 101 < degrees, degrees <= 123 { return "ESE".localized() }
        else if 123 < degrees, degrees <= 146 { return "SE".localized() }
        else if 146 < degrees, degrees <= 168 { return "SSE".localized() }
        else if 168 < degrees, degrees <= 191 { return "S".localized() }
        else if 191 < degrees, degrees <= 213 { return "SSW".localized() }
        else if 213 < degrees, degrees <= 236 { return "SW".localized() }
        else if 236 < degrees, degrees <= 258 { return "WSW".localized() }
        else if 258 < degrees, degrees <= 281 { return "W".localized() }
        else if 281 < degrees, degrees <= 303 { return "WNW".localized() }
        else if 303 < degrees, degrees <= 326 { return "NW".localized() }
        else if 326 < degrees, degrees < 348 { return "NNW".localized() }
        return ""
    }
    
}

extension Model: LocationServiceOutput {
    
    func setCoordinates(longitude: Double, latitude: Double) {
        settings.longitude = longitude
        settings.latitude = latitude
        update()
    }
    
    func setCity(_ city: String) {
        self.city = city
        delegates.forEach { (observer) in
            observer.value?.cityUpdated(city)
        }
    }
    
    func getLocale() -> Locale {
        return Locale.init(identifier: settings.language.rawValue)
    }
    
}

extension Model: WeatherServiceOutput {
    func weatherUpdated(_ json: WeatherJSON?, error: Error?, silent: Bool = true) {
        if let error = error {
            if !silent {
                self.delegates.forEach { (observer) in
                    DispatchQueue.main.async {
                        observer.value?.errorOccured(error)
                    }
                }
            }
            print(error)
            return
        }
        if let weather = self.jsonToEntity(json) {
            self.delegates.forEach { (observer) in
                DispatchQueue.main.async {
                    observer.value?.currentWeatherUpdated(weather)
                }
            }
        }
    }
    
    func forecastUpdated(_ json: [WeatherJSON]?, error: Error?, silent: Bool = true) {
        if let error = error {
            if !silent {
                self.delegates.forEach { (observer) in
                    DispatchQueue.main.async {
                        observer.value?.errorOccured(error)
                    }
                }
            }
            print(error)
            return
        }
        if let forecast = self.jsonToEntity(json) {
            self.delegates.forEach { (observer) in
                DispatchQueue.main.async {
                    observer.value?.forecastUpdated(forecast)
                }
            }
        }
    }
    
    
}

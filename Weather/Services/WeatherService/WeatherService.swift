
import Foundation

protocol WeatherServiceOutput: AnyObject {
    func weatherUpdated(_ json: WeatherJSON?, error: Error?, silent: Bool)
    func forecastUpdated(_ json: [WeatherJSON]?, error: Error?, silent: Bool)
}

protocol WeatherServiceInput {
    func getWeather(_ settings: Settings, silent: Bool)
    func getForecast(_ settings: Settings, silent: Bool)
}

class WeatherService: NSObject, WeatherServiceInput {
    
    private static let baseUrl = "https://api.openweathermap.org"
    private static let apiKey = "b54fd86d759d2ad51b278ee151ef4cf5"
    
    private static let weather = "/data/2.5/weather"
    private static let forecast = "/data/2.5/forecast"
    
    weak var delegate: WeatherServiceOutput?
     
    init(delegate: WeatherServiceOutput?) {
        super.init()
        self.delegate = delegate
    }
    
    func getParameters(_ settings: Settings) -> [String: String] {
        return [
            "lang" : settings.language.rawValue,
            "units" : settings.units.rawValue,
            "lat" : settings.latitude.description,
            "lon" : settings.longitude.description,
            "APPID" : WeatherService.apiKey
        ]
    }
    
    func getWeather(_ settings: Settings, silent: Bool) {
        if var url = URL.init(string: WeatherService.baseUrl + WeatherService.weather) {
            let params = getParameters(settings)
            url = URL.url(url: url, params: params)
            let session = URLSession.shared
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if let error = error {
                    self?.delegate?.weatherUpdated(nil, error: error, silent: silent)
                } else if let data = data {
                    do {
                        let json = try JSONDecoder().decode(WeatherJSON.self, from: data)
                        self?.delegate?.weatherUpdated(json, error: nil, silent: silent)
                    } catch {
                        self?.delegate?.weatherUpdated(nil, error: error, silent: silent)
                    }
                } else {
                    self?.delegate?.weatherUpdated(nil, error: EmptyResponseError(), silent: silent)
                }
            }
            task.resume()
        }
    }
    
    func getForecast(_ settings: Settings, silent: Bool) {
       if var url = URL.init(string: WeatherService.baseUrl + WeatherService.forecast) {
           let params = getParameters(settings)
           url = URL.url(url: url, params: params)
           let session = URLSession.shared
           let task = session.dataTask(with: url) { [weak self] (data, response, error) in
               if let error = error {
                   self?.delegate?.forecastUpdated(nil, error: error, silent: silent)
               } else if let data = data {
                   do {
                       let json = try JSONDecoder().decode(ForecastJSON.self, from: data)
                       self?.delegate?.forecastUpdated(json.list, error: nil, silent: silent)
                   } catch {
                       self?.delegate?.forecastUpdated(nil, error: error, silent: silent)
                   }
               } else {
                   self?.delegate?.forecastUpdated(nil, error: EmptyResponseError(), silent: silent)
               }
           }
           task.resume()
       }
   }
    
}

class EmptyResponseError: Error {
    
}

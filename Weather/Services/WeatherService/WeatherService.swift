
import Foundation

class WeatherService {
    
    private static let baseUrl = "https://api.openweathermap.org"
    private static let apiKey = "b54fd86d759d2ad51b278ee151ef4cf5"
    
    private static let weather = "/data/2.5/weather"
    private static let forecast = "/data/2.5/forecast"
    
    
    func getWeather(_ settings: Settings, completion:  ((WeatherJSON?, Error?)->())?) {
        if var url = URL.init(string: WeatherService.baseUrl + WeatherService.weather) {
            let params = getParameters(settings)
            url = URL.url(url: url, params: params)
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion?(nil, error)
                }
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode(WeatherJSON.self, from: data)
                        completion?(json, nil)
                    } catch {
                        completion?(nil, error)
                    }
                } else {
                    completion?(nil, EmptyResponseError())
                }
            }
            task.resume()
        }
    }
    
     func getForecast(_ settings: Settings, completion:  (([WeatherJSON]?, Error?)->())?) {
        if var url = URL.init(string: WeatherService.baseUrl + WeatherService.forecast) {
            let params = getParameters(settings)
            url = URL.url(url: url, params: params)
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    completion?(nil, error)
                }
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode(ForecastJSON.self, from: data)
                        completion?(json.list, nil)
                    } catch {
                        print(error)
                        completion?(nil, error)
                    }
                } else {
                    completion?(nil, EmptyResponseError())
                }
            }
            task.resume()
        }
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
}

class EmptyResponseError: Error {
    
}

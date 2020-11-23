
import Foundation

class WeatherService {
    
    static let baseUrl = "https://api.openweathermap.org"
    static let apiKey = "b54fd86d759d2ad51b278ee151ef4cf5"
    
    static let weather = "/data/2.5/weather"
    static let forecast = "/data/2.5/forecast"
    
    
    static func getWeather(_ settings: Settings, completion:  ((WeatherJSON?, Error?)->())?) {
        if var url = URL.init(string: baseUrl + weather) {
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
    
    static func getForecast(_ settings: Settings, completion:  (([WeatherJSON]?, Error?)->())?) {
        if var url = URL.init(string: baseUrl + forecast) {
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
    
    static func getParameters(_ settings: Settings) -> [String: String] {
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

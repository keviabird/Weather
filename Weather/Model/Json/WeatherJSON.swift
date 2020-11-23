
import Foundation

class WeatherJSON: Decodable {
    var date = 0.0
    var temperature = 0.0
    var sunrise: Double? = 0.0
    var sunset: Double? = 0.0
    var visibility = 0
    var weatherName = ""
    var weatherIcon = ""
    var windSpeed = 0.0
    var windDegrees = 0
    
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case weather
        case wind
        case sys
        case visibility
    }
    
    enum MainKeys: String, CodingKey {
        case temperature = "temp"
    }
    
    enum WeatherKeys: String, CodingKey {
        case description
        case icon
    }
    
    enum WindKeys: String, CodingKey {
        case speed
        case deg
    }
    
    enum SysKeys: String, CodingKey {
        case sunrise
        case sunset
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try values.decode(Double.self, forKey: .date)
        self.visibility = try values.decode(Int.self, forKey: .visibility)
        
        let mainValues = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        self.temperature = try mainValues.decode(Double.self, forKey: .temperature)
            
        var weatherValues = try values.nestedUnkeyedContainer(forKey: .weather)
        let firstWeatherValues = try weatherValues.nestedContainer(keyedBy: WeatherKeys.self)
        self.weatherName = try firstWeatherValues.decode(String.self, forKey: .description)
        self.weatherIcon = try firstWeatherValues.decode(String.self, forKey: .icon)
            
        let windValues = try values.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        self.windSpeed = try windValues.decode(Double.self, forKey: .speed)
        self.windDegrees = try windValues.decode(Int.self, forKey: .deg)
        
        let sysValues = try values.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        self.sunrise = try? sysValues.decode(Double.self, forKey: .sunrise)
        self.sunset = try? sysValues.decode(Double.self, forKey: .sunset)
    }
}

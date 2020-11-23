
import Foundation

extension URL {
    
    static func url(url: URL, params: [String: String]? = nil) -> URL {
        
        var components = URLComponents.init(url: url, resolvingAgainstBaseURL: true)
        if components?.queryItems == nil {
            components?.queryItems = []
        }
        
        for (key, value) in params ?? [:] {
            components?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return components?.url ?? url
    }
    
}

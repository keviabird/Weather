
import Foundation

// from https://openweathermap.org/forecast5#multi
enum Language: String, CaseIterable {
    case en
    case de
    case hi
    case it
    case ja
    case ru
    
    func getTitle() -> String {
        switch self {
        case .en:
            return "English"
        case .de:
            return "German"
        case .hi:
            return "Hindi"
        case .it:
            return "Italian"
        case .ja:
            return "Japanese"
        case .ru:
            return "Russian"
        }
    }
}

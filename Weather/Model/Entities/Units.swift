
import Foundation

enum Units: String, CaseIterable {
    case metric
    case imperial
    
    func getTitle() -> String {
        switch self {
        case .metric:
            return "Metric".localized()
        case .imperial:
            return "Imperial".localized()
        }
    }
}

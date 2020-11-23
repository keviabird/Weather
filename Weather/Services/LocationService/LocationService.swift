
import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static private var service = LocationService()

    var locationManager: CLLocationManager?
    
    private override init() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    static func startService() {
        service.locationManager?.delegate = service
        service.locationManager?.startUpdatingLocation()
        updateCity()
    }
    
    static func updateCity(location: CLLocation? = nil) {
        if let location = location ?? service.locationManager?.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: Model.shared.getSettings().language.rawValue)) { (placemarks, error) in
                if let placemark = placemarks?.last {
                    Model.shared.setCity(placemark.locality ?? "")
                }
            }
        }
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Model.shared.setCoordinates(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        LocationService.updateCity(location: location)
    }
    
}
